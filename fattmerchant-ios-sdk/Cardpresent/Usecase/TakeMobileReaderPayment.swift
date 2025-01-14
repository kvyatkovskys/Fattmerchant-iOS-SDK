//
//  TakeMobileReaderPayment.swift
//  fattmerchant-ios-sdk
//
//  Created by Tulio Troncoso on 1/16/20.
//  Copyright © 2020 Fattmerchant. All rights reserved.
//

import Foundation

enum TakeMobileReaderPaymentException: OmniException {
  case mobileReaderNotFound
  case mobileReaderNotReady
  case invoiceNotFound
  case couldNotCreateInvoice(detail: String?)
  case couldNotCreateCustomer(detail: String?)
  case couldNotCreatePaymentMethod(detail: String?)
  case couldNotUpdateInvoice(detail: String?)
  case couldNotCreateTransaction(detail: String?)

  static var mess: String = "Error taking mobile reader payment"

  var detail: String? {
    switch self {
    case .mobileReaderNotFound:
      return "Mobile reader not found"

    case .mobileReaderNotReady:
      return "Mobile reader not ready to take payment"

    case .invoiceNotFound:
      return "Invoice with given id not found"

    case .couldNotCreateInvoice(let d):
      return d ?? "Could not create invoice"

    case .couldNotCreateCustomer(let d):
      return d ?? "Could not create customer"

    case .couldNotCreatePaymentMethod(let d):
      return d ?? "Could not create payment method"

    case .couldNotUpdateInvoice(let d):
      return d ?? "Could not update invoice"

    case .couldNotCreateTransaction(let d):
      return d ?? "Could not create transaction"
    }
  }

}

class TakeMobileReaderPayment {

  typealias Exception = TakeMobileReaderPaymentException

  var mobileReaderDriverRepository: MobileReaderDriverRepository
  var invoiceRepository: InvoiceRepository
  var customerRepository: CustomerRepository
  var paymentMethodRepository: PaymentMethodRepository
  var transactionRepository: TransactionRepository
  var request: TransactionRequest
  var signatureProvider: SignatureProviding?
  weak var transactionUpdateDelegate: TransactionUpdateDelegate?

  init(
    mobileReaderDriverRepository: MobileReaderDriverRepository,
    invoiceRepository: InvoiceRepository,
    customerRepository: CustomerRepository,
    paymentMethodRepository: PaymentMethodRepository,
    transactionRepository: TransactionRepository,
    request: TransactionRequest,
    signatureProvider: SignatureProviding?,
    transactionUpdateDelegate: TransactionUpdateDelegate?) {

    self.mobileReaderDriverRepository = mobileReaderDriverRepository
    self.invoiceRepository = invoiceRepository
    self.customerRepository = customerRepository
    self.paymentMethodRepository = paymentMethodRepository
    self.transactionRepository = transactionRepository
    self.request = request
    self.signatureProvider = signatureProvider
    self.transactionUpdateDelegate = transactionUpdateDelegate
  }

  func start(completion: @escaping (Transaction) -> Void, failure: @escaping (OmniException) -> Void) {
    availableMobileReaderDriver(mobileReaderDriverRepository, failure) { driver in

      self.getOrCreateInvoice(failure) { (createdInvoice) in

        self.takeMobileReaderPayment(with: driver,
                                     signatureProvider: self.signatureProvider,
                                     transactionUpdateDelegate: self.transactionUpdateDelegate,
                                     failure) { (mobileReaderPaymentResult) in

          self.createCustomer(mobileReaderPaymentResult, failure) { (createdCustomer) in

            self.createPaymentMethod(for: createdCustomer, mobileReaderPaymentResult, failure) { (createdPaymentMethod) in

              self.updateInvoice(createdInvoice, with: createdPaymentMethod, and: createdCustomer, failure) { (updatedInvoice) in

                self.createTransaction(
                  result: mobileReaderPaymentResult,
                  paymentMethod: createdPaymentMethod,
                  customer: createdCustomer,
                  invoice: updatedInvoice,
                  failure,
                  completion
                )
              }
            }
          }
        }
      }
    }
  }

  internal func createTransaction(result: TransactionResult, paymentMethod: PaymentMethod, customer: Customer, invoice: Invoice, _ failure: @escaping (OmniException) -> Void, _ completion: @escaping (Transaction) -> Void) {
    let transactionToCreate = Transaction()

    guard let paymentMethodId = paymentMethod.id else {
      failure(Exception.couldNotUpdateInvoice(detail: "Payment method id is required"))
      return
    }

    guard let lastFour = getLastFour(for: result.maskedPan) else {
        failure(Exception.couldNotCreatePaymentMethod(detail: "Could not retrieve masked pan"))
        return
    }

    guard let transactionMetaJson = createTransactionMetaJson(from: result) else {
      failure(Exception.couldNotCreateTransaction(detail: "Could not generate transaction meta json"))
      return
    }

    var gatewayResponseJson: JSONValue?

    if let authCode = result.authCode, result.source.lowercased() == "nmi" {
      let gatewayResponse = [
        "gateway_specific_response_fields": [
          "nmi": [
            "authcode": authCode
          ]
        ]
      ]

      gatewayResponseJson = gatewayResponse.jsonValue()
    }

    guard let customerId = customer.id else {
      failure(Exception.couldNotCreateTransaction(detail: "Customer id is required"))
      return
    }

    guard let invoiceId = invoice.id else {
      failure(Exception.couldNotCreateTransaction(detail: "Invoice id is required"))
      return
    }

    transactionToCreate.paymentMethodId = paymentMethodId
    transactionToCreate.total = request.amount.dollars()
    transactionToCreate.success = result.success ?? false
    transactionToCreate.lastFour = lastFour
    transactionToCreate.meta = transactionMetaJson
    transactionToCreate.type = "charge"
    transactionToCreate.method = "card"
    transactionToCreate.source = "iOS|CPSDK|\(result.source)"
    transactionToCreate.customerId = customerId
    transactionToCreate.invoiceId = invoiceId
    transactionToCreate.response = gatewayResponseJson
    transactionToCreate.token = result.externalId
    transactionToCreate.message = result.message

    transactionRepository.create(model: transactionToCreate, completion: completion, error: failure)
  }

  /// Creates a JSONValue object that from the transactionResult, including only the items that make up the TransactionMeta
  /// - Parameter transactionResult: the TransactionResult object to be converted into transaction meta
  fileprivate func createTransactionMetaJson(from transactionResult: TransactionResult) -> JSONValue? {
    var dict: [String: String] = [:]

    //TODO: Move this somewhere outside the UseCase
    #if !targetEnvironment(simulator)
    if transactionResult.source.contains(ChipDnaDriver.source) {
      if let userRef = transactionResult.userReference {
        dict["nmiUserRef"] = userRef
      }

      if let localId = transactionResult.localId {
        dict["cardEaseReference"] = localId
      }

      if let externalId = transactionResult.externalId {
        dict["nmiTransactionId"] = externalId
      }
    }
//    else if transactionResult.source.contains(AWCDriver.source) {
//      if let externalId = transactionResult.externalId {
//        dict["awcTransactionId"] = externalId
//      }
//    }
    #endif

    if let gatewayResponse = transactionResult.gatewayResponse {
      dict["gatewayResponse"] = gatewayResponse
    }

    return dict.jsonValue()
  }

  fileprivate func updateInvoice(_ invoice: Invoice,
                                 with paymentMethod: PaymentMethod,
                                 and customer: Customer,
                                 _ failure: @escaping (OmniException) -> Void,
                                 completion: @escaping (Invoice) -> Void) {
    let newInvoice = Invoice()

    guard let id = invoice.id else {
      failure(Exception.couldNotUpdateInvoice(detail: "Invoice id is required"))
      return
    }

    guard let paymentMethodId = paymentMethod.id else {
      failure(Exception.couldNotUpdateInvoice(detail: "Payment method id is required"))
      return
    }

    guard let customerId = customer.id else {
      failure(Exception.couldNotUpdateInvoice(detail: "Customer id is required"))
      return
    }

    newInvoice.customerId = customerId
    newInvoice.paymentMethodId = paymentMethodId
    invoiceRepository.update(model: newInvoice, id: id, completion: completion, error: failure)
  }

  fileprivate func getLastFour(for maskedPan: String?) -> String? {
    guard
      let maskedPan = maskedPan,
      maskedPan.count > 4,
      let lastFourIdx = maskedPan.index(maskedPan.endIndex, offsetBy: -4, limitedBy: maskedPan.startIndex) else {
        return nil
    }

    return String(maskedPan.suffix(from: lastFourIdx))
  }

  fileprivate func createPaymentMethod(for customer: Customer, _ result: TransactionResult, _ failure: @escaping (OmniException) -> Void, completion: @escaping (PaymentMethod) -> Void) {
    let paymentMethodToCreate = PaymentMethod()

    guard let customerId = customer.id else {
      failure(Exception.couldNotCreateCustomer(detail: "Customer id is required"))
      return
    }

    guard let lastFour = getLastFour(for: result.maskedPan) else {
      failure(Exception.couldNotCreatePaymentMethod(detail: "Could not retrieve masked pan"))
      return
    }

    guard let cardType = result.cardType else {
      failure(Exception.couldNotCreateCustomer(detail: "Card type is required"))
      return
    }

    paymentMethodToCreate.cardExp = result.cardExpiration
    paymentMethodToCreate.customerId = customerId
    paymentMethodToCreate.method = PaymentMethodType.card
    paymentMethodToCreate.cardLastFour = lastFour
    paymentMethodToCreate.cardType = cardType
    paymentMethodToCreate.personName = "\(customer.firstname ?? "") \(customer.lastname ?? "")"
    paymentMethodToCreate.tokenize = false
    paymentMethodToCreate.paymentToken = result.paymentToken

    // When the payment method was tokenized, we want to use the
    // createTokenizedPaymentMethod method since it tells Omni to save the token
    if paymentMethodToCreate.paymentToken != nil {
      paymentMethodRepository.createTokenizedPaymentMethod(model: paymentMethodToCreate, completion: completion, error: failure)
    } else {
      paymentMethodRepository.create(model: paymentMethodToCreate, completion: completion, error: failure)
    }

  }

  fileprivate func createCustomer(_ transactionResult: TransactionResult, _ failure: @escaping (OmniException) -> Void, _ completion: @escaping (Customer) -> Void) {
    let customerToCreate = Customer()
    customerToCreate.firstname = transactionResult.cardHolderFirstName ?? "SWIPE"
    customerToCreate.lastname = transactionResult.cardHolderLastName ?? "CUSTOMER"
    customerRepository.create(model: customerToCreate, completion: completion, error: failure)
  }

  fileprivate func takeMobileReaderPayment(with driver: MobileReaderDriver,
                                           signatureProvider: SignatureProviding?,
                                           transactionUpdateDelegate: TransactionUpdateDelegate?,
                                           _ failure: (OmniException) -> Void,
                                           _ completion: @escaping (TransactionResult) -> Void) {
    driver.performTransaction(with: self.request, signatureProvider: signatureProvider, transactionUpdateDelegate: transactionUpdateDelegate, completion: completion)
  }

  /// Gets the invoice with the id in the transaction request or creates a new one
  internal func getOrCreateInvoice(_ failure: @escaping (OmniException) -> Void, _ completion: @escaping (Invoice) -> Void) {
    // If an invoiceId was given in the transaction request, we should verify that an invoice with that id exists
    if let invoiceId = request.invoiceId {
      invoiceRepository.getById(id: invoiceId, completion: completion) { (error) in
        failure(TakeMobileReaderPaymentException.invoiceNotFound)
      }
    } else {
      let invoiceToCreate = Invoice()
      invoiceToCreate.total = request.amount.dollars()
      invoiceToCreate.url = "https://fattpay.com/#/bill"
      let invoiceMeta = [
        "subtotal": self.request.amount.dollarsString()
      ]

      guard let invoiceMetaJson = invoiceMeta.jsonValue() else {
        failure(Exception.couldNotCreateInvoice(detail: "Error generating json for meta"))
        return
      }

      invoiceToCreate.meta = invoiceMetaJson
      invoiceRepository.create(model: invoiceToCreate, completion: completion, error: failure)
    }
  }

  fileprivate func availableMobileReaderDriver(_ repo: MobileReaderDriverRepository, _ failure: @escaping (OmniException) -> Void, _ completion: @escaping (MobileReaderDriver) -> Void) {
    repo.getInitializedDrivers { initializedDrivers in
      // Get drivers that are ready for payment
      filter(items: initializedDrivers, predicate: { $0.isReadyToTakePayment }) { driversReadyForPayment in
        guard let driver = driversReadyForPayment.first else {
          failure(TakeMobileReaderPaymentException.mobileReaderNotFound)
          return
        }

        completion(driver)
      }
    }
  }

}

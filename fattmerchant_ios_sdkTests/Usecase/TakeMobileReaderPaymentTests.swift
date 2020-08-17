//
//  TakeMobileReaderTests.swift
//  FattmerchantTests
//
//  Created by Tulio Troncoso on 5/19/20.
//  Copyright © 2020 Fattmerchant. All rights reserved.
//

import Foundation
import XCTest

class TakeMobileReaderPaymentTests: XCTestCase {

  var mockOmniApi: MockOmniApi = MockOmniApi()
  var mobileReaderDriverRepo: MobileReaderDriverRepository!
  var invoiceRepo: InvoiceRepository!
  var customerRepo: CustomerRepository!
  var paymentMethodRepo: PaymentMethodRepository!
  var transactionRepo: TransactionRepository!

  override func setUp() {
    invoiceRepo = InvoiceRepository(omniApi: mockOmniApi)
    customerRepo = CustomerRepository(omniApi: mockOmniApi)
    paymentMethodRepo = PaymentMethodRepository(omniApi: mockOmniApi)
    transactionRepo = TransactionRepository(omniApi: mockOmniApi)
    mobileReaderDriverRepo = MobileReaderDriverRepository()
  }

  func testCanTakeMobileReaderPayment() {
    let transactionCompleted = expectation(description: "Transaction was successfully completed")

    let transactionRequest = TransactionRequest(amount: Amount(cents: 1), tokenize: true)
    TakeMobileReaderPayment(
      mobileReaderDriverRepository: mobileReaderDriverRepo,
      invoiceRepository: invoiceRepo,
      customerRepository: customerRepo,
      paymentMethodRepository: paymentMethodRepo,
      transactionRepository: transactionRepo,
      request: transactionRequest,
      signatureProvider: nil,
      transactionUpdateDelegate: nil
    ).start(completion: { completedTransaction in
      transactionCompleted.fulfill()
    }) { exception in
      XCTFail("Transaction failed")
    }

    wait(for: [transactionCompleted], timeout: 10.0)
  }

  func testCreateTransactionIsCreatedWithToken() {
    let transactionRequest = TransactionRequest(amount: Amount(cents: 1), tokenize: true)
    let job = TakeMobileReaderPayment(
      mobileReaderDriverRepository: mobileReaderDriverRepo,
      invoiceRepository: invoiceRepo,
      customerRepository: customerRepo,
      paymentMethodRepository: paymentMethodRepo,
      transactionRepository: transactionRepo,
      request: transactionRequest,
      signatureProvider: nil,
      transactionUpdateDelegate: nil
    )

    // Verify that the externalId is put in the transaction
    let transactionHasExternalId = expectation(description: "Transaction has external id")
    let paymentMethod = PaymentMethod()
    paymentMethod.id = "payment-method-id"

    let customer = Customer()
    customer.id = "customer-id"

    let invoice = Invoice()
    invoice.id = "invoice-id"

    var result = TransactionResult()
    result.externalId = "externalId"
    result.maskedPan = "41111111111111111"

    job.createTransaction(result: result,
                          paymentMethod: paymentMethod,
                          customer: customer,
                          invoice: invoice,
                          { exception in
                            XCTFail()
                          }, { transaction in
                            XCTAssertEqual(transaction.token, result.externalId)
                            transactionHasExternalId.fulfill()
                          })

    wait(for: [transactionHasExternalId], timeout: 10.0)
  }

  func testTransactionRequestWithInvalidIdFails() {
    let badInvoiceId = "notreal"
    let transactionRequest = TransactionRequest(amount: Amount(cents: 1), tokenize: true, invoiceId: badInvoiceId)
    let job = TakeMobileReaderPayment(
      mobileReaderDriverRepository: mobileReaderDriverRepo,
      invoiceRepository: invoiceRepo,
      customerRepository: customerRepo,
      paymentMethodRepository: paymentMethodRepo,
      transactionRepository: transactionRepo,
      request: transactionRequest,
      signatureProvider: nil,
      transactionUpdateDelegate: nil
    )

    let expectedError = TakeMobileReaderPaymentException.invoiceNotFound
    let expectation = XCTestExpectation(description: "Transaction fails")

    job.start(completion: { _ in
      XCTFail("Transaction didn't fail")
    }) { error in
      XCTAssertEqual(error.message, expectedError.message)
      if case TakeMobileReaderPaymentException.invoiceNotFound = error {
        expectation.fulfill()
      } else {
        XCTFail("Wrong error thrown")
      }
    }

    wait(for: [expectation], timeout: 10.0)
  }

  func testTransactionRequestWithIdDoesNotCreateNewInvoice() {
    // Add one single invoice to the modelStore
    let invoiceId = UUID().uuidString
    let invoice = Invoice()
    invoice.id = invoiceId

    modelStore = [invoiceId: invoice]

    let transactionRequest = TransactionRequest(amount: Amount(cents: 1), tokenize: true, invoiceId: invoiceId)
    let job = TakeMobileReaderPayment(
      mobileReaderDriverRepository: mobileReaderDriverRepo,
      invoiceRepository: invoiceRepo,
      customerRepository: customerRepo,
      paymentMethodRepository: paymentMethodRepo,
      transactionRepository: transactionRepo,
      request: transactionRequest,
      signatureProvider: nil,
      transactionUpdateDelegate: nil
    )
    
    let expectation = XCTestExpectation(description: "No other invoices are in the modelStore")

    job.start(completion: { transaction in
      XCTAssertEqual(modelStore.values.filter { $0 is Invoice }.count, 1)
      XCTAssertEqual(transaction.invoiceId, invoiceId)
      expectation.fulfill()
    }) { error in
      XCTFail("Transaction failed")
    }

    wait(for: [expectation], timeout: 10.0)
  }
  
  func testTransactionRequestWithCatalogItems() {
    // Create a list of catalog items
    var requestedItems = [CatalogItem]()
    
    let testItem1 = CatalogItem(id: "fakeid1", item: "TestItem1", details: "Test item number one", quantity: 1, price: 0.1)
    let testItem2 = CatalogItem(id: "fakeid2", item: "TestItem2", details: "Test item number two", quantity: 1, price: 0.5)
    let testItem3 = CatalogItem(id: "fakeid3", item: "TestItem2", details: "Test item number three", quantity: 3, price: 0.2)
    
    requestedItems.append(testItem1)
    requestedItems.append(testItem2)
    requestedItems.append(testItem3)
    
    let transactionRequest = TransactionRequest(amount: Amount(cents: 8), lineItems: requestedItems)
    let job = TakeMobileReaderPayment(
      mobileReaderDriverRepository: mobileReaderDriverRepo,
      invoiceRepository: invoiceRepo,
      customerRepository: customerRepo,
      paymentMethodRepository: paymentMethodRepo,
      transactionRepository: transactionRepo,
      request: transactionRequest,
      signatureProvider: nil,
      transactionUpdateDelegate: nil
    )
    
    let expectation = XCTestExpectation(description: "Result of transaction has catalog items that match the requested catalog items")
  
    job.start(completion: { transaction in
      if let meta = transaction.meta {
        if let lineItems = meta.lineItems {
          XCTAssertTrue(lineItems.allSatisfy({ item in
            requestedItems.contains { requestedItem in
              item.id == requestedItem.id
            }
          }))
        } else {
          XCTFail("Failed to get catalog items")
        }
      }
      expectation.fulfill()
    }) { error in
      XCTFail("Transaction failed")
    }
    
    wait(for: [expectation], timeout: 10.0)
  }

}

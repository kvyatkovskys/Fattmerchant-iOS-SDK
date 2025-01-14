//
//  WebpaymentsTokenize.swift
//  fattmerchant-ios-sdk
//
//  Created by Tulio Troncoso on 4/2/20.
//  Copyright © 2020 Fattmerchant. All rights reserved.
//

import Foundation

enum TokenizePaymentMethodException: OmniException {
  static var mess: String = "Could not tokenize payment method"

  case tokenizationError
  case couldNotParsePaymentMethodError
  case merchantMissingHostedPaymentsToken
}

/// Tokenizes a payment method
class TokenizePaymentMethod {

  typealias Exception = TokenizePaymentMethodException

  /// Responsible for communicating with Omni
  var omniApi: OmniApi

  /// The Merchant that will be associated with the tokenized payment method
  var merchant: Merchant

  /// Initializes a TokenizePaymentMethod instance with OmniApi and Merchant
  init(omniApi: OmniApi, merchant: Merchant) {
    self.omniApi = omniApi
    self.merchant = merchant
  }

  func start<T: Codable>(codablePaymentMethod: T, completion: @escaping (PaymentMethod) -> Void, failure: @escaping (OmniException) -> Void) {
    guard let hostedPaymentsToken = merchant.hostedPaymentsToken else {
      failure(Exception.merchantMissingHostedPaymentsToken)
      return
    }
    tokenize(codablePaymentMethod, webpaymentsToken: hostedPaymentsToken, completion: completion, failure: failure)
  }

  private func tokenize<T: Codable>(_ codablePaymentMethod: T, webpaymentsToken: String, completion: @escaping (PaymentMethod) -> Void, failure: @escaping (TokenizePaymentMethodException) -> Void) {
    guard let data = encode(codablePaymentMethod: codablePaymentMethod) else {
      failure(.couldNotParsePaymentMethodError)
      return
    }

    let path = "/webpayment/\(webpaymentsToken)/tokenize"

    omniApi.request(method: "post", urlString: path, body: data, completion: completion) { _ in
      failure(.couldNotParsePaymentMethodError)
    }

  }

  internal func encode<T: Codable>(codablePaymentMethod: T) -> Data? {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    return try? encoder.encode(codablePaymentMethod)
  }

}

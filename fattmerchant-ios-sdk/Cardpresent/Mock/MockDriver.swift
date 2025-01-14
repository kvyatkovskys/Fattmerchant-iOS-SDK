//
//  MockDriver.swift
//  FattmerchantTests
//
//  Created by Tulio Troncoso on 1/18/20.
//  Copyright © 2020 Fattmerchant. All rights reserved.
//

import Foundation

class MockDriver: MobileReaderDriver {

  weak var mobileReaderConnectionStatusDelegate: MobileReaderConnectionStatusDelegate?

  var reader: MobileReader? = MobileReader(name: "Reader",
                            firmwareVersion: "FakeFirmwareVersion",
                            make: "FakeMake",
                            model: "FakeModel",
                            serialNumber: "FakeSerialNumber")

  /// Set this to false to simulate a busy mobile reader
  var readyToTakePayment = true

  var familiarSerialNumbers: [String] = []

  var isInitialized: Bool = true
  var shouldConnect: Bool = true

  static var source: String = "MOCKSOURCE"

  static var omniRefundsSupported: Bool = false

  func isReadyToTakePayment(completion: (Bool) -> Void) {
    completion(readyToTakePayment)
  }

  func initialize(args: [String: Any], completion: (Bool) -> Void) {
    completion(true)
  }

  func isInitialized(completion: @escaping (Bool) -> Void) {
    completion(isInitialized)
  }

  func searchForReaders(args: [String: Any], completion: @escaping ([MobileReader]) -> Void) {
    completion([reader!])
  }

  func connect(reader: MobileReader, completion: @escaping (MobileReader?) -> Void) {
    guard shouldConnect else {
      return completion(nil)
    }

    if let serial = reader.serialNumber {
      familiarSerialNumbers.append(serial)
    }

    completion(reader)
  }

  func disconnect(reader: MobileReader, completion: @escaping (Bool) -> Void, error: @escaping (OmniException) -> Void) {
    completion(true)
  }

  func getConnectedReader(completion: (MobileReader?) -> Void, error: @escaping (OmniException) -> Void) {
    completion(reader)
  }

  func performTransaction(with request: TransactionRequest, signatureProvider: SignatureProviding?, transactionUpdateDelegate: TransactionUpdateDelegate?, completion: @escaping (TransactionResult) -> Void) {
    let transactionResult = TransactionResult(
      request: request,
      success: true,
      maskedPan: "411111111234",
      cardHolderFirstName: "William",
      cardHolderLastName: "Holder",
      authCode: "abc123",
      transactionType: "charge",
      amount: request.amount,
      cardType: "visa",
      userReference: "cdm-123123"
    )

    completion(transactionResult)
  }

  func cancelCurrentTransaction(completion: @escaping (Bool) -> Void, error: @escaping (OmniException) -> Void) {
    completion(true)
  }

  func refund(transaction: Transaction, completion: @escaping (TransactionResult) -> Void, error: @escaping (OmniException) -> Void) {
    refund(transaction: transaction, refundAmount: nil, completion: completion, error: error)
  }

  func refund(transaction: Transaction, refundAmount: Amount?, completion: @escaping (TransactionResult) -> Void, error: @escaping (OmniException) -> Void) {
    let transactionResult = TransactionResult(
      request: nil,
      success: true,
      maskedPan: "411111111234",
      cardHolderFirstName: "William",
      cardHolderLastName: "Holder",
      authCode: "def456",
      transactionType: "refund",
      amount: Amount(cents: 5),
      cardType: "visa",
      userReference: "cdm-123123"
    )

    completion(transactionResult)
  }

  func refund(transaction: Transaction, completion: @escaping (TransactionResult) -> Void) {
    let transactionResult = TransactionResult(
      request: nil,
      success: true,
      maskedPan: "411111111234",
      cardHolderFirstName: "William",
      cardHolderLastName: "Holder",
      authCode: "def456",
      transactionType: "refund",
      amount: Amount(cents: 5),
      cardType: "visa",
      userReference: "cdm-123123"
    )

    completion(transactionResult)
  }

}

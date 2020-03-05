---
layout: page
title: Create A Token
permalink: /payment-method-tokenization/ios/create-a-token
parent: iOS
grand_parent: Payment Method Tokenization
nav_order: 2
---

# Create a Token

## Setup

You'll first need to setup the `FattmerchantApi` for usage.  All you have to do here is set the `webPaymentsToken` field on the shared `FattmerchantConfiguration`. `FattmerchantApi` will then use that configuration by default.

```swift
import UIKit
import Fattmerchant

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FattmerchantConfiguration.shared.webPaymentsToken = "mywebpaymentstoken"
    return true
  }
}
```

Alternatively, you may create a configuration object and pass it to the new `FattmerchantApi` instance as you need it.

```swift
let configuration = FattmerchantConfiguration(webPaymentsToken: "mywebpaymentstoken")
let fattClient = FattmerchantApi(configuration: configuration)
```

## Collect payment information
You first want to collect credit card information and instantiate a `CreditCard` or a `BankAccount` object.

```swift
let card = CreditCard(personName: "Joan Parsnip",
                      cardNumber: "4111111111111111",
                      cardExp: "1220",
                      addressZip: "32814")


// Or for a bank account...
let bankAccount = BankAccount(routingNumber: "021000021",
                              accountNumber: "38294738291937485",
                              bankHolderType: .personal,
                              accountType: .checking)
```

## Associate a Customer (optional)
If you want to associate a Customer with the new `PaymentMethod`, set the `customerId` on the `CreditCard` or `BankAccount`

```swift
let card = CreditCard(personName: "Joan Parsnip",
                      cardNumber: "4111111111111111",
                      cardExp: "1220",
                      addressZip: "32814",
                      customerId: "7404cae1-86ba-408c-bb43-8c5cacfdcaab")
```

## Get a payment method token
Once you have a `CreditCard` object, call the `tokenize(:)` method on  `FattmerchantAPI` object and pass a block to run once tokenization is complete.

```swift
let fattClient = FattmerchantApi(webPaymentsToken: "mywebpaymentstoken")
fattClient.tokenize(card) { (response) in
  if case let .success(paymentMethod) = response {
    let paymentToken = paymentMethod.id
    print("I must now use \(paymentToken) to create a payment.")
  }
  // Success! You can now run a transaction with Fattmerchant using paymentToken as the PaymentMethod
}
```

Or you can set a delegate to be notified.

```swift
class MyClass: FattmerchantApiDelegate {

  func gottaHaveThatFunc() {
    // ...
    let fattClient = FattmerchantApi(webPaymentsToken: "mywebpaymentstoken")
    fattClient.delegate = self
    fattClient.tokenize(card)
  }

  func fattmerchantApi(_ fattmerchantApi: FattmerchantApi, didCreatePaymentMethod paymentMethod: PaymentMethod) {
    let paymentToken = paymentMethod.id
    // You can now run a transaction with Fattmerchant using paymentToken as the PaymentMethod
  }
  
  func fattmerchantApi(_ fattmerchantApi: FattmerchantApi, didReceiveError: Error) {
    if case let .tokenizationError(errors) = error {
      print("Uh oh! 😡 We got errors!")
      errors.forEach { print($0) }
    }
  }
}
```

---

<button type="button" name="button" class="btn" style="float: right;">
<a href="/payment-method-tokenization/ios/testing/">Next: Testing</a>
</button>

<div style="margin-bottom: 10%"> </div>
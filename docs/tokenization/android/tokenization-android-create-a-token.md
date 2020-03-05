---
layout: page
title: Create A Token
permalink: /payment-method-tokenization/android/create-a-token
parent: Android
grand_parent: Payment Method Tokenization
nav_order: 2
---

# Create a Token

To accept a payment, you'll need to collect information from the customer, tokenize it, and send the token to your server. Your server will then be responsible for using the Fattmerchant API to run the transaction.

### Setup

You'll first need to setup the `FattmerchantClient` for usage.  All you have to do here is set the `webPaymentsToken` field on the shared `FattmerchantConfiguration`. `FattmerchantClient` will then use that configuration by default.

```kotlin
class MyApplication: Application() {
    override fun onCreate() {
       super.onCreate()
		FattmerchantConfiguration.shared.webPaymentsToken = "mywebpaymentstoken"
    }
}
```

Alternatively, you may create a configuration object and pass it to the new `FattmerchantApi` instance as you need it.

```kotlin
val config = FattmerchantConfiguration("https://apidev01.fattlabs.com", "fattwars")
val client = FattmerchantClient(config)
```

### Collect payment information
You first want to collect credit card information and populate a `CreditCard` or a `BankAccount` object.

```kotlin
val creditCard = CreditCard(personName = "Joan Parsnip",
	cardNumber = "4111111111111111",
	cardExp = "1230",
	addressZip = "32822")

// Or for a bank account...
val bankAccount = BankAccount(personName = "Jim Parsnip",
	bankType = "savings",
	bankAccount = "9876543210",
	bankRouting = "021000021",
	addressZip = "32822")
```

### Get a payment method token
Once you have a `CreditCard` object, call the `tokenize(:)` method on  `FattmerchantClient` object and pass a listener to be notified once tokenization is complete.

```kotlin
var fattClient = FattmerchantClient(config)
fattClient.tokenize(card) { (response) in
  client.tokenize(card, object : FattmerchantClient.TokenizationListener {
            override fun onPaymentMethodCreated(paymentMethod: PaymentMethod) {
              // Success! You can now run a transaction with Fattmerchant using paymentToken as the PaymentMethod
            }

            override fun onPaymentMethodCreateError(errors: String) {
                System.out.print(errors)
            }
        })
}
```

---

<button type="button" name="button" class="btn" style="float: right;">
<a href="/payment-method-tokenization/android/testing/">Next: Testing</a>
</button>

<div style="margin-bottom: 10%"> </div>
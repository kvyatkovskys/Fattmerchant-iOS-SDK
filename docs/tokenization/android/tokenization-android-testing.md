---
layout: page
title: Testing
permalink: /payment-method-tokenization/android/testing
parent: Android
grand_parent: Payment Method Tokenization
nav_order: 3
---

# Testing
If you'd like to try tokenization without real payment information, you can use the `CreditCard.testCreditCard()` or `BankAccount.testBankAccount()` methods to get a test credit card or bank account.

```kotlin
val creditCard = CreditCard.testCreditCard()

val bankAccount = BankAccount.testBankAccount()
```

If you want to test failures, you can use the following methods

```kotlin
val failingCreditCard = CreditCard.failingTestCreditCard()

val failingBankAccount = BankAccount.failingTestBankAccount()
```

Or you can create the `CreditCard` or `BankAccount` object with the following testing payment information:

#### Credit card numbers

| Card Type | Good Card | Bad Card |
|---------|--------------------|-----------|
|VISA|4111111111111111|4012888888881881|
|Mastercard|5555555555554444|5105105105105100|
|Amex|378282246310005|371449635398431|
|Discover|6011111111111117|6011000990139424|
|JCB|3569990010030400|3528327757705979|
|Diners Club|30569309025904|30207712915383|

> Use any CVV number for the above

#### Bank routing & account numbers

|---|---|
|Routing|021000021|
|Account|9876543210|

To test failing bank accounts, use the given routing number and any other account number

---

<button type="button" name="button" class="btn" style="float: right;">
<a href="/payment-method-tokenization/android/taking-a-payment/">Next: Taking a Payment</a>
</button>

<div style="margin-bottom: 10%"> </div>
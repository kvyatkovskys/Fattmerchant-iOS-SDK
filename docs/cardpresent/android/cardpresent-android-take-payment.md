---
layout: page
title: Take a Payment
permalink: /mobile-reader-payments/android/take-payment
parent: android
grand_parent: Mobile Reader Payments
nav_order: 4
---

# Take a Payment

To take a payment, simply create a `TransactionRequest` and pass it along to `omni.takeMobileReaderTransaction(...)`

```kotlin
// Create an Amount
var amount = Amount(50)
    
// Create the TransactionRequest
var request = TransactionRequest(amount)
    
// Take the payment
Omni.shared()?.takeMobileReaderTransaction(request, {
    // Payment successful!
}) {
    // Error
}
```

---

<button type="button" name="button" class="btn" style="float: right;">
<a href="/mobile-reader-payments/android/refund-payment/">Next: Refund Payment</a>
</button>

<div style="margin-bottom: 10%"> </div>


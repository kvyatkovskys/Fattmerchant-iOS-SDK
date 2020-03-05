---
layout: page
title: Take a Payment
permalink: /mobile-reader-payments/ios/take-payment
parent: ios
grand_parent: Mobile Reader Payments
nav_order: 4
---

# Take a Payment

To take a payment, simply create a `TransactionRequest` and pass it along to `omni.takeMobileReaderTransaction(...)`

```swift
// Create an Amount
let amount = Amount(cents: 50)
    
// Create the TransactionRequest
let request = TransactionRequest(amount: amount)
    
// Take the payment
omni.takeMobileReaderTransaction(request, { completedTransaction in
    // Payment successful!
}) {
    // Error
}
```

---

<button type="button" name="button" class="btn" style="float: right;">
<a href="/mobile-reader-payments/ios/refund-payment/">Next: Refund Payment</a>
</button>

<div style="margin-bottom: 10%"> </div>


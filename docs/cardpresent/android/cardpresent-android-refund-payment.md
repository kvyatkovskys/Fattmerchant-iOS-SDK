---
layout: page
title: Refund Payment
permalink: /mobile-reader-payments/android/refund-payment
parent: android
grand_parent: Mobile Reader Payments
nav_order: 5
---

# Refund a Payment

To refund a payment, you must first get the `Transaction` that you want to refund. You can use the [Omni API](https://fattmerchant.docs.apiary.io/#reference/0/transactions) to do so. 
Once you get the transaction, you can use the `refundMobileReaderTransaction` method to attempt the refund.

> At this time, you may only refund transactions that were performed on the same device that performed the original transaction

```kotlin
// Attain a transaction
var transaction = Transaction()
    
// Perform refund
Omni.shared()?.refundMobileReaderTransaction(transaction, {
    // Refund successful!
}) {
    // Error
}
```

<div style="margin-bottom: 10%"> </div>
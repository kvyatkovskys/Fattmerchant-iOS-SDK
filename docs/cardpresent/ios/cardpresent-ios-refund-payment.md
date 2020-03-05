---
layout: page
title: Refund Payment
permalink: /mobile-reader-payments/ios/refund-payment
parent: ios
grand_parent: Mobile Reader Payments
nav_order: 5
---

# Refund a Payment

. You can use the [Omni API](https://fattmerchant.docs.apiary.io/#reference/0/transactions) to do so. 
Once you get the transaction, you can use the `refundMobileReaderTransaction` method to attempt the refund.

> At this time, you may only refund transactions that were performed on the same device that performed the original transaction 


```swift
// Attain a transaction
var transaction = Transaction()
    
// Perform refund
omni.refundMobileReaderTransaction(transaction: transaction, completion: { (refundedTransaction) in
	// Refund successful!
}, error: { error in
	// Error
})
```

<div style="margin-bottom: 10%"> </div>
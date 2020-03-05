---
layout: page
title: Taking a Payment
permalink: /payment-method-tokenization/ios/taking-a-payment
parent: iOS
grand_parent: Payment Method Tokenization
nav_order: 4
---

# Taking a Payment
Now that you have the token representing the payment method, you can use the `POST /charge` resource on the Omni API. this will allow you to create a transaction with the payment method. `payment_method_id` is a required field, where you will need to pass in the id of the payment method that you received from the `tokenize(:)` method.

<button type="button" name="button" class="btn"><a href="https://fattmerchant.docs.apiary.io/#reference/0/charge/charge-a-payment-method">Omni API: Charge a Payment Method</a></button>

<div style="margin-bottom: 10%"> </div>
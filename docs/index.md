---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
title: Home
nav_order: 0
---

# **Omni Mobile SDK**

Fattmerchant's Omni Mobile SDK is a collection of SDKs allowing integration with the Fattmerchant platform for tokenizing card-not-present payment methods and taking mobile reader payments. 

---

# Capabilities

## Mobile Reader Payments
Supercharge your mobile app by quickly adding mobile reader payments using the Omni Mobile SDK. These payments will create invoices, customers, and transaction objects in the Omni platform. You can also choose to have the payment method stored within Omni so you can use it from the Omni API. 

### How it works
1. You'll first need to create an ephemeral key to initialize the `Omni` object.
2. Then you'll create a `TransactionRequest` that holds all necessary data to take a payment.
3. Finally, you'll ask `Omni` to take the payment by calling the `takeMobileReaderPayment()` method, passing in the `TransactionRequest` and a block to run once the payment is complete

<button type="button" name="button" class="btn"><a href="/mobile-reader-payments">Mobile Reader Payment Guide</a></button>

--- 

## Tokenization
The Omni Mobile SDK provides a simple way to accept a payment on your mobile app by providing tokenization of payment methods. By using these tokens instead of card and bank information, you no longer have to worry about sending sensitive card information to your server.

> Note This feature facilitates payments when you have card data and not a Fattmerchant-provided mobile reader. If you do have a Fattmerchant-provided mobile reader, then see the [Mobile Reader Payments](#mobile-reader-payments) section below

### How it works

1. Collect card or bank account data.
2. Then pass the card/bank account data to the Omni Mobile SDK. This creates a [`PaymentMethod`](https://fattmerchant.docs.apiary.io/#reference/0/payment-methods) in Omni and returns the id.
3. Using the `PaymentMethod` id, you can now use the `transaction/charge` route in the Omni API to perform a transaction. 

<button type="button" name="button" class="btn"><a href="/payment-method-tokenization">Tokenization Guide</a></button>



---
layout: page
title: Requirements & Limitations
permalink: /requirements-and-limitations/
nav_order: 1
---

## Requirements
* All features of the Omni Mobile SDK are only available to [Omni](https://fattmerchant.com/) Merchants.
* Must be developing a Native iOS App or a Native Android app
* Must have access to the Omni API

## Limitations
* Only Mobile Reader Payments and Payment Method Tokenization are available at this time. After tokenizing a payment method, you will need to run a payment through the [Omni API](https://fattmerchant.docs.apiary.io/#reference/0/charge/charge-a-payment-method) using the payment method token.
* Mobile Reader Payments do not capture signatures
* All features require an active internet connection. Offline tokenization and payments are not supported
* There is no support for Customers or itemized transactions in the SDKs. However, you can leverage the [Omni API](https://fattmerchant.docs.apiary.io/#reference/0/customers) to create robust invoices rich with Customer and Catalog Item information.
* There is no official support for React Native, Cordova, or Flutter plugins.
* Omni Mobile SDK does not provide any UI elements

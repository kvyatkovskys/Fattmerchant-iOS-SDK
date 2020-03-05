---
layout: page
title: Initialize
permalink: /mobile-reader-payments/ios/initialize
parent: ios
grand_parent: Mobile Reader Payments
nav_order: 2
---

# Getting Started

## Setup Info.plist
In order to build and run with the Cardpresent functionality, you must include the following items in your project's `Info.plist`

* **NSBluetoothAlwaysUsageDescription**: Provide a value here to let your users know why Bluetooth access is required
* **UISupportedExternalAccessoryProtocols**: Include and array of the following items here. These are the MobileReaders that the Omni Cardpresent SDK supports
	* com.bbpost.bt.wisepad
	* com.miura.shuttle
	* com.datecs.pinpad

## Initialize

Create an instance of `InitParams`

```swift
var initParams = Omni.InitParams(appId: "fmiossample", apiKey: apiKey, environment: Environment.DEV)
```

Pass the initParams to `Omni.initialize(...)`, along with a completion lambda and an error lambda

```swift
omni = Omni()

log("Attempting initalization...")

// Initialize Omni
omni?.initialize(params: initParams, completion: {
	// Initialized! 
}) { (error) in
	
}
```

---

<button type="button" name="button" class="btn" style="float: right;">
<a href="/mobile-reader-payments/ios/connect-reader/">Next: Connect a Mobile Reader</a>
</button>

<div style="margin-bottom: 10%"> </div>
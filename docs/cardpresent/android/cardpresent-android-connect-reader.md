---
layout: page
title: Connect Reader
permalink: /mobile-reader-payments/android/connect-reader
parent: android
grand_parent: Mobile Reader Payments
nav_order: 3
---

# Connect a Mobile Reader

> Before connecting to a Miura reader, the reader must be paired to the Android device within the Settings app


In order to connect a mobile reader, you must first search for a list of available readers

```kotlin
Omni.shared().getAvailableReaders { readers ->
	
}
```

Once you have the list of available ones, you can choose which one you'd like to connect

```kotlin
Omni.shared().getAvailableReaders { readers ->
	Omni.shared().connectReader(mobileReader, onConnected: { reader ->
		// Reader is connected
	}, onFail: { error ->
		// Error connecting reader
	}
}
```

---

<button type="button" name="button" class="btn" style="float: right;">
<a href="/mobile-reader-payments/android/take-payment/">Next: Take a Payment</a>
</button>

<div style="margin-bottom: 10%"> </div>
---
layout: page
title: Connect Reader
permalink: /mobile-reader-payments/ios/connect-reader
parent: ios
grand_parent: Mobile Reader Payments
nav_order: 3
---

# Connect a Mobile Reader

> Before connecting to a Miura reader, the reader must be paired to the iOS device within the Settings app


In order to connect a mobile reader, you must first search for a list of available readers

```swift
omni.getAvailableReaders { readers ->
	
}
```

Once you have the list of available ones, you can choose which one you'd like to connect

```swift
omni?.getAvailableReaders(completion: { readers in
	guard !readers.isEmpty else {
		self.log("No readers found")
		return
	}
	
	var chosenReader = ... // Choose a reader
	
	omni.connect(reader: chosenReader, completion: { connectedReader in
		self.log("Connected reader: \(connectedReader)")
	}) { (error) in
		// Something went wrong
	}	
}) { 
	self.log("Couldn't connect to the mobile reader")
}
```

---

<button type="button" name="button" class="btn" style="float: right;">
<a href="/mobile-reader-payments/ios/take-payment/">Next: Take a Payment</a>
</button>

<div style="margin-bottom: 10%"> </div>
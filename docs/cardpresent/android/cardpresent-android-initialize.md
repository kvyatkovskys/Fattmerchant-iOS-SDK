---
layout: page
title: Initialize
permalink: /mobile-reader-payments/android/initialize
parent: android
grand_parent: Mobile Reader Payments
nav_order: 2
---

# Getting Started

Create an instance of `InitParams`

```kotlin
var initParams = InitParams(applicationContext, ephemeralApiKey, OmniApi.Environment.DEV)
```

Pass the initParams to `Omni.initialize(...)`, along with a completion lambda and an error lambda

```kotlin
Omni.initialize(params, {
	// Success!
    System.out.println("Omni is initialized")
}) {
	// There was an error
}
```

You can now use `Omni.shared()` to get the instance of Omni that you will be using


---

<button type="button" name="button" class="btn" style="float: right;">
<a href="/mobile-reader-payments/android/connect-reader/">Next: Connect a Mobile Reader</a>
</button>

<div style="margin-bottom: 10%"> </div>
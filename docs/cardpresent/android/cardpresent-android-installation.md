---
layout: page
title: Installation
permalink: /mobile-reader-payments/android/installation
parent: android
grand_parent: Mobile Reader Payments
nav_order: 1
---

# Installation

## Jitpack
To install,

1. Add the JitPack repository to your build file

```
allprojects {
  repositories {
    ...
    maven { url 'https://jitpack.io' }
  }
}
```

2. Add the following line to your `build.gradle` file

```
implementation 'com.github.fattmerchantorg:fattmerchant-android-sdk:v1.0.4'
```
---

<button type="button" name="button" class="btn" style="float: right;">
<a href="/mobile-reader-payments/android/initialize">Next: Initialize Omni Object</a>
</button>

<div style="margin-bottom: 10%"> </div>

---
title: Download-to-Go for iOS
---

# PlayKit VR for iOS

PlayKit VR is an iOS library that used for monoscopic 360 video playback & VR.
VR view allows you to embed 360 degree VR media into mobile, and native apps on iOS. This technology is designed to enable developers of traditional apps to enhance the apps with immersive content.

## Supported Features 

- Monoscopic 360 video playback (Panorama View).
- Split screen option for VR (Stereo View).

| Features
|---------
| Built on top of SceneKit + Metal
| Distorted stereo view for Cardboard
| Smooth touch rotation and re-centering
| Custom SCNScene presentation
| Written in Swift 3

## Supported Platforms

- Xcode 8.2+
- iOS 9.0+
- Swift 3.0+
- Metal (Apple A7+)

## Supported Formats

- HLS
- MP4

## Known Limitations

- [`Metal`](https://developer.apple.com/documentation/metal) is not supported in the iOS Simulator, please run your application on real device.

### Simple Flow

![](Resources/basicFlow.png)

## Installation

### [CocoaPods][cocoapods]

Add this to your podfile:
```ruby
pod 'PlayKitVR'
```

## Overview

TBD

[cocoapods]: https://cocoapods.org/

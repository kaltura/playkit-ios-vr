---
title: Download-to-Go for iOS
---

# PlayKit VR for iOS

PlayKit VR is an iOS library that used for monoscopic 360 video playback & VR.
VR view allows you to embed 360 degree VR media into mobile, and native apps on iOS. This technology is designed to enable developers of traditional apps to enhance the apps with immersive content.

|                          | Features
|--------------------------|---------
| :metal:                  | Built on top of SceneKit + Metal
| :eyes:                   | Distorted stereo view for Cardboard
| :point_up_2:             | Smooth touch rotation and re-centering
| :sunrise_over_mountains: | Custom SCNScene presentation
| :bird:                   | Written in Swift 3


## Supported Features 
- Monoscopic 360 video playback.
- Split the screen option for VR.

## Supported Platforms

- Xcode 8.2+
- iOS 9.0+
- Swift 3.0+
- Metal (Apple A7+)

## Supported Formats

- HLS
- MP4

## Player Events and States

- http://cocoadocs.org/docsets/PlayKit/3.2.1/Classes/PlayerEvent.html

## Known Limitations

- `Metal` is not supported in the iOS Simulator, please run your application with PlayKitVR on real device.

## Installation

### [CocoaPods][cocoapods]

Add this to your podfile:
```ruby
pod 'PlayKitVR'
```

## Overview

TBD

[cocoapods]: https://cocoapods.org/

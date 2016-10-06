# OHCubeView
Scroll view subclass inspired by the Instagram Stories cube.

![demonstration](/ohcubeview2.gif)

### Requirements
- iOS >= 9.0
- Autolayout

## Installation

### CocoaPods

In your podfile, add `pod 'OHCubeView'` and run `pod install`. Done!

## Usage

- Using interface builder, add a UIScrollView instance to the storyboard and make it a subclass of OHCubeView. Hook the instance up to an `IBOutlet` in the view controller.

![Usage 1](/usage-1.png)

- In your view controller, programmatically add subviews to the cube view (note that this can be any kind of UIView subclass). Layout constraints are automatically added to the subviews.

![Usage 1](/usage-2.png)

## TODOs
- Swift 3 support
- Support for infinite paging

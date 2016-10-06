# OHCubeView
Scroll view subclass inspired by the Instagram Stories cube.

## Installation

### CocoaPods

`pod 'OHCubeView'`

## Usage

1. Using interface builder, add a UIScrollView instance to the storyboard and make it a subclass of OHCubeView

![Usage 1](/usage-1.png)

2. In your view controller, programmatically add subviews to the cube view (note that this can be any kind of UIView subclass). Layout constraints are automatically added to the subviews.

![Usage 1](/usage-2.png)

## TODOs
- Swift 3 support
- Support for infinite paging

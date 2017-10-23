# OHCubeView
Scroll view subclass inspired by the Instagram Stories cube.

![demonstration](/Resources/ohcubeview-demonstration.gif)

### Requirements
- iOS >= 9.0
- Autolayout

#### N.B.
Only supports portrait mode.

## Installation

### CocoaPods

In your podfile, add `pod 'OHCubeView'` and run `pod install`. Done!

## Usage

- Using interface builder, add a UIScrollView instance to the storyboard and make it a subclass of OHCubeView. Hook the instance up to an `IBOutlet` in the view controller.

![Usage 1](/Resources/usage-1.png)

- In your view controller, programmatically add subviews to the cube view (note that this can be any kind of UIView subclass). Layout constraints are automatically added to the subviews.

```swift
import UIKit
import OHCubeView

class ViewController: UIViewController {

    @IBOutlet weak var cubeView: OHCubeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Create subviews for our cube view (in this case, five image views)
        
        let iv1 = UIImageView(image: UIImage(named: "img1"))
        let iv2 = UIImageView(image: UIImage(named: "img2"))
        let iv3 = UIImageView(image: UIImage(named: "img3"))
        let iv4 = UIImageView(image: UIImage(named: "img4"))
        let iv5 = UIImageView(image: UIImage(named: "img5"))
        
        // 2. Add all subviews to the cube view
        
        cubeView.addChildViews([iv1, iv2, iv3, iv4, iv5])
    }
}
```

## TODOs
- Support for infinite paging
- Add custom delegate methods

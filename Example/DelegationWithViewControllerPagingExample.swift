//
//  ViewController.swift
//  Example
//
//  Created by Yadigar Berkay Zengin on 12.04.2021.
//  Copyright © 2021 Oyvind Hauge. All rights reserved.
//

import UIKit
import OHCubeView

class DelegationWithViewControllerPagingExample: UIViewController {

    @IBOutlet weak var pagerViewController: OHCubePagerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pagerViewController.delegate = self
        pagerViewController.setPage(0)
    }
    
}

extension DelegationWithViewControllerPagingExample: OHCubePagerViewDelegate {
    
    func cubePageView(numberOfItemsIn cubePageView: OHCubePagerView) -> Int {
        return 3
    }
    
    func cubePageView(_ cubePageView: OHCubePagerView, viewController atIndex: Int) -> UIViewController? {
        if atIndex < 3 {
            let vc = UIViewController()
            switch atIndex {
            case 0:
                vc.view.backgroundColor = .red
            case 1:
                vc.view.backgroundColor = .blue
            case 2:
                vc.view.backgroundColor = .green
            default:
                break
            }
            return vc
        }
        return nil
    }
    
    func cubePageView(_ cubePageView: OHCubePagerView, didPageChange pageIndex: Int, viewController: UIViewController) {
        print("New page is: \(pageIndex)")
    }
    
    func cubePageView(_ cubePageView: OHCubePagerView, didScroll scrollPercentage: CGFloat, scrollTo side: OHCubeBasePageController.ScrollDirection) {
        print("Scrolling to side \(side.rawValue == 0 ? "left" : "right") \(scrollPercentage)")
    }
    
}


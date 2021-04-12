//
//  ProgrammaticWithViewImplementation.swift
//  Example
//
//  Created by Yadigar Berkay Zengin on 12.04.2021.
//  Copyright © 2021 Oyvind Hauge. All rights reserved.
//

import UIKit
import OHCubeView

class ProgrammaticWithViewImplementation : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pagerViewController = OHCubePagerView()
        pagerViewController.delegate = self
        pagerViewController.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pagerViewController)

        guard let view = view else { return }
        let c1 = view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: pagerViewController.leadingAnchor)
        let c2 = view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: pagerViewController.topAnchor)
        let c3 = view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: pagerViewController.trailingAnchor)
        let c4 = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: pagerViewController.bottomAnchor)
        NSLayoutConstraint.activate([c1, c2, c3, c4])
        
        let view1 = UIView()
        view1.backgroundColor = .red

        let view2 = UIView()
        view2.backgroundColor = .blue

        let view3 = UIView()
        view3.backgroundColor = .purple

        pagerViewController.addChildViews([view1, view2, view3])
        
    }
    
}

extension ProgrammaticWithViewImplementation: OHCubePagerViewDelegate {
    
    func cubePageView(_ cubePageView: OHCubePagerView, didPageChange pageIndex: Int, viewController: UIViewController) {
        print("New page is: \(pageIndex)")
    }
    
    func cubePageView(_ cubePageView: OHCubePagerView, didScroll scrollPercentage: CGFloat, scrollTo side: OHCubeBasePageController.ScrollDirection) {
        print("Scrolling to side \(side.rawValue == 0 ? "left" : "right") \(scrollPercentage)")
    }
    
    
}

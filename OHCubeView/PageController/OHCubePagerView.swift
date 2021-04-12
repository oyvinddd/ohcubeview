//
//  OHCubePagerView.swift
//  OHCubeView
//
//  Created by Yadigar Berkay Zengin on 11.04.2021.
//  Copyright © 2021 Oyvind Hauge. All rights reserved.
//

import UIKit

@objc public protocol OHCubePagerViewDelegate {
    @objc optional func cubePageView(_ cubePageView: OHCubePagerView, viewController atIndex: Int) -> UIViewController?
    @objc optional func cubePageView(numberOfItemsIn cubePageView: OHCubePagerView) -> Int
    @objc func cubePageView(_ cubePageView: OHCubePagerView, didPageChange pageIndex: Int, viewController: UIViewController)
    @objc func cubePageView(_ cubePageView: OHCubePagerView, didScroll scrollPercentage: CGFloat, scrollTo side: OHCubeBasePageController.ScrollDirection)
}


@available(iOS 9.0, *) @IBDesignable
open class OHCubePagerView: UIView {
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        initLayout()
    }
    
    open weak var delegate: OHCubePagerViewDelegate?
    fileprivate var childViews = [UIView]()
    fileprivate var currentItemIndex = 0
    
    fileprivate var pageController: OHCubeBasePageController!
    
    fileprivate func initLayout() {
        
        let _pageController = OHCubeBasePageController.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageController = _pageController
        self.addSubview(pageController.view)
        
        pageController.ohDelegate = self
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(.init(item: pageController.view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(.init(item: pageController.view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        addConstraint(.init(item: pageController.view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        addConstraint(.init(item: pageController.view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        

        pageController.delegate = self
        pageController.dataSource = self
        
    }
    
    open func addChildView(_ view: UIView) {
        var shouldLoadPager = false
        if childViews.count == 0 {
            shouldLoadPager = true
        }
        
        childViews.append(view)
        pageController.reloadInputViews()
        
        if shouldLoadPager { loadInitailController() }
    }
    
    open func addChildViews(_ views: [UIView]) {
        var shouldLoadPager = false
        if childViews.count == 0 {
            shouldLoadPager = true
        }
        
        childViews.append(contentsOf: views)
        pageController.reloadInputViews()
        
        if shouldLoadPager { loadInitailController() }
    }
    
    open func setPage(_ index: Int, direction: UIPageViewController.NavigationDirection = .forward, is animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let vc = getVC(for: index) else { return }
        currentItemIndex = index
        pageController.setViewControllers([vc], direction: direction, animated: animated, completion: completion)
    }
    
}

extension OHCubePagerView: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    fileprivate func loadInitailController() {
        pageController.setViewControllers([getVC(for: currentItemIndex)!], direction: .forward, animated: true, completion: nil)
    }
    
    fileprivate func getVC(for index: Int) -> UIViewController? {
        var numberOfMaxItems = childViews.count - 1
        if let delegationMaxItems = delegate?.cubePageView?(numberOfItemsIn: self) {
            numberOfMaxItems = delegationMaxItems - 1
        }
        
        if (index < 0 || index > numberOfMaxItems) {
            return nil
        }
        
        let _vcFromDelegate = delegate?.cubePageView?(self, viewController: index)
        
        var _vc: UIViewController!
        if _vcFromDelegate == nil {
            let _v = childViews[index]
            _vc = UIViewController()
            
            _v.translatesAutoresizingMaskIntoConstraints = false
            _vc.view.addSubview(_v)
            _vc.view.addConstraint(
                .init(
                    item: _vc.view,
                    attribute: .leading,
                    relatedBy: .equal,
                    toItem: _v,
                    attribute: .leading,
                    multiplier: 1,
                    constant: 0
                )
            )
            
            _vc.view.addConstraint(
                .init(
                    item: _vc.view,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: _v,
                    attribute: .top,
                    multiplier: 1,
                    constant: 0
                )
            )
            
            _vc.view.addConstraint(
                .init(
                    item: _vc.view,
                    attribute: .trailing,
                    relatedBy: .equal,
                    toItem: _v,
                    attribute: .trailing,
                    multiplier: 1,
                    constant: 0
                )
            )
            
            _vc.view.addConstraint(
                .init(
                    item: _vc.view,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: _v,
                    attribute: .bottom,
                    multiplier: 1,
                    constant: 0
                )
            )
            
        } else {
            _vc = _vcFromDelegate!
        }
        
        _vc.view.tag = index
        return _vc
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let firstVC = pageController.viewControllers?.first else { return }
        let addedInView = firstVC.view.subviews.first
        currentItemIndex = childViews.firstIndex(where: { (view) -> Bool in
            return view == addedInView
        }) ?? firstVC.view.tag
        delegate?.cubePageView(self, didPageChange: currentItemIndex, viewController: firstVC)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getVC(for: currentItemIndex - 1)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getVC(for: currentItemIndex + 1)
    }
    
}

extension OHCubePagerView: OHCubeBasePageControllerDelegate {
    
    public func cubeBasePageController(didScroll percent: CGFloat, toSide: OHCubeBasePageController.ScrollDirection) {
        delegate?.cubePageView(self, didScroll: percent, scrollTo: toSide)
    }
    
}

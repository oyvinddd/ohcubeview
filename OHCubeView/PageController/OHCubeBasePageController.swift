//
//  OHCuvePageController.swift
//  OHCubeView
//
//  Created by Yadigar Berkay Zengin on 11.04.2021.
//  Copyright © 2021 Oyvind Hauge. All rights reserved.
//

import UIKit

@objc public protocol OHCubeBasePageControllerDelegate {
    @objc func cubeBasePageController(didScroll percent: CGFloat, toSide: OHCubeBasePageController.ScrollDirection)
}

@available(iOS 9.0, *)
open class OHCubeBasePageController : UIPageViewController {
    
    weak var ohDelegate: OHCubeBasePageControllerDelegate?
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        initLayout()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        initLayout()
    }
    
    fileprivate func initLayout() {
        if let scrollView = view.subviews.first as? UIScrollView {
            scrollView.delegate = self
        }
        
    }
    
}

extension OHCubeBasePageController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        animateVCTransition(scrollView)
        
        let w = scrollView.frame.width
        if scrollView.contentOffset.x != w {
            var scrollSide = ScrollDirection.left
            if scrollView.contentOffset.x >= scrollView.frame.width {
                scrollSide = ScrollDirection.left
            } else {
                scrollSide = ScrollDirection.right
            }
            
            if scrollSide == .left {
                let scroll = scrollView.contentOffset.x - w
                let percent = max(0, min(1, 1.0/w*scroll))
                ohDelegate?.cubeBasePageController(didScroll: percent, toSide: scrollSide)
            } else {
                let scroll = scrollView.contentOffset.x
                let percent = max(0, min(1, 1.0-(1.0/w*scroll)))
                ohDelegate?.cubeBasePageController(didScroll: percent, toSide: scrollSide)
            }
        }
    }
    
    fileprivate func animateVCTransition(_ scrollView: UIScrollView? = nil) {
            
        guard let scrollView = scrollView else { return }
        
        let maxAngle: CGFloat = 60
        let xOffset = scrollView.contentOffset.x
        let svWidth = scrollView.frame.width
        var deg = maxAngle / scrollView.frame.width * xOffset
        
        for index in 0 ..< scrollView.subviews.count {
            
            let view = scrollView.subviews[index]
            
            deg = index == 0 ? deg : deg - maxAngle
            let rad = deg * CGFloat(Double.pi / 180)
            
            var transform = CATransform3DIdentity
            transform.m34 = 1 / 500
            transform = CATransform3DRotate(transform, rad, 0, 1, 0)
            
            view.layer.transform = transform
            
            let x = xOffset / svWidth > CGFloat(index) ? 1.0 : 0.0
            setAnchorPoint(CGPoint(x: x, y: 0.5), forView: view)
            
            applyShadowForView(scrollView, view, index: index)
        }
        
    }
    
    fileprivate func applyShadowForView(_ scrollView: UIScrollView, _ view: UIView, index: Int) {
            
        let w = scrollView.frame.width
        let h = scrollView.frame.height
        
        let r1 = frameFor(origin: scrollView.contentOffset, size: scrollView.frame.size)
        let r2 = frameFor(origin: CGPoint(x: CGFloat(index)*w, y: 0),
                          size: CGSize(width: w, height: h))
        
        // Only show shadow on right-hand side
        if r1.origin.x <= r2.origin.x {
            
            let intersection = r1.intersection(r2)
            let intArea = intersection.size.width*intersection.size.height
            let union = r1.union(r2)
            let unionArea = union.size.width*union.size.height
            
            view.layer.opacity = Float(intArea / unionArea) + 0.2
        }
    }
    
    fileprivate func setAnchorPoint(_ anchorPoint: CGPoint, forView view: UIView) {
 
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    fileprivate func frameFor(origin: CGPoint, size: CGSize) -> CGRect {
        return CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
    }
    
}


extension OHCubeBasePageController {
    
    @objc public enum ScrollDirection: Int { case left = 0; case right = 1 }
    
}

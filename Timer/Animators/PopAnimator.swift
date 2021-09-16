//
//  PopAnimator.swift
//  Timer
//
//  Created by Gin Imor on 9/15/21.
//  
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  let duration = 0.4
  var isPresenting = true
  var originFrame = CGRect.zero
  var didDismiss: (() -> Void)?

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let settingNav = transitionContext.view(forKey: isPresenting ? .to : .from)!
    let settingNavController = transitionContext.viewController(forKey: isPresenting ? .to : .from) as! UINavigationController
    let settingViewController = settingNavController.topViewController as! SettingViewController
    
    let finalFrame = isPresenting ? settingNav.frame : originFrame
    
    let xFactor = originFrame.width / settingNav.frame.width
    let yFactor = originFrame.height / settingNav.frame.height
    
    let scaleTransform = CGAffineTransform(scaleX: xFactor, y: yFactor)
    
    if isPresenting {
      settingNav.transform = scaleTransform
      settingNav.center = CGPoint(x: originFrame.midX, y: originFrame.midY)
    } else {
      settingViewController.hideBarButtonItems()
    }
    
    if let toView = transitionContext.view(forKey: .to) {
      containerView.addSubview(toView)
      containerView.bringSubviewToFront(settingNav)
    }
    
    settingNavController.transitionCoordinator?.animate(alongsideTransition: { (context) in
      // in animateTransition, outlet not set yet
      settingViewController.containerViewAlpha = self.isPresenting ? 1.0 : 0.0
    })

    UIView.animate(withDuration: duration) {
      settingNav.transform = self.isPresenting ? .identity : scaleTransform
      settingNav.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
    } completion: { (completed) in
      transitionContext.completeTransition(true)
      if !self.isPresenting { self.didDismiss?() }
      settingViewController.showBarButtonItems()
    }
  }
  
}

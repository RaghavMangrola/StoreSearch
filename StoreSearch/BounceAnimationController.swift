//
//  BounceAnimationController.swift
//  StoreSearch
//
//  Created by Raghav Mangrola on 11/13/15.
//  Copyright © 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class BounceAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 0.4
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    if let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
      let toView = transitionContext.viewForKey(UITransitionContextToViewKey),
      let containerView = transitionContext.containerView() {
        
        
        toView.frame = transitionContext.finalFrameForViewController(toViewController)
        containerView.addSubview(toView)
        toView.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        UIView.animateKeyframesWithDuration(transitionDuration(transitionContext), delay: 0, options: .CalculationModeCubic, animations: {
          UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.334, animations: {
            toView.transform = CGAffineTransformMakeScale(1.2, 1.2)
            //            toView.transform = CGAffineTransformMakeRotation(CGFloat(0.7 * M_PI))
          })
          UIView.addKeyframeWithRelativeStartTime(0.334, relativeDuration: 0.333, animations: {
            toView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            //            toView.transform = CGAffineTransformMakeRotation(CGFloat(1.4 * M_PI))
          })
          UIView.addKeyframeWithRelativeStartTime(0.666, relativeDuration: 0.333, animations: {
            toView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            //            toView.transform = CGAffineTransformMakeRotation(CGFloat(2 * M_PI))
          })
          }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
  }
}

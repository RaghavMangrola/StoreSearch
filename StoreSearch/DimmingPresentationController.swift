//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Raghav Mangrola on 11/24/15.
//  Copyright © 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
  
  lazy var dimmingView = GradientView(frame: CGRect.zero)
  
  override func presentationTransitionWillBegin() {
    dimmingView.frame = containerView!.bounds
    containerView!.insertSubview(dimmingView, atIndex: 0)
  }
  
  override func shouldRemovePresentersView() -> Bool {
    return false
  }
}

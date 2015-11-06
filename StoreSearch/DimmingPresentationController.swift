//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Raghav Mangrola on 11/24/15.
//  Copyright © 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
  override func shouldRemovePresentersView() -> Bool {
    return false
  }
}

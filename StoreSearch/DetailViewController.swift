//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Raghav Mangrola on 11/23/15.
//  Copyright © 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBAction func close() {
    dismissViewControllerAnimated(true, completion: nil)
  }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    modalPresentationStyle = .Custom
    transitioningDelegate = self
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: UIViewControllerTransitioningDelegate {
  func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
    
    return DimmingPresentationController(
                      presentedViewController: presented,
                      presentingViewController: presenting)
  }
}
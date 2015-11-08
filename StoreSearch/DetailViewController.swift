//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Raghav Mangrola on 11/23/15.
//  Copyright © 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  var searchResult: SearchResult!
  var downloadTask: NSURLSessionDownloadTask!
  
  @IBOutlet weak var popupView: UIView!
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var kindLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var priceButton: UIButton!
  
  @IBAction func close() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func openInStore() {
    if let url = NSURL(string: searchResult.storeURL) {
      UIApplication.sharedApplication().openURL(url)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    let gestureRecognzier = UITapGestureRecognizer(target: self, action: Selector("close"))
    
    view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
    popupView.layer.cornerRadius = 10
    
    gestureRecognzier.cancelsTouchesInView = false
    gestureRecognzier.delegate = self
    view.addGestureRecognizer(gestureRecognzier)
    
    if searchResult != nil {
      updateUI()
    }
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
  
  func updateUI() {
    nameLabel.text = searchResult.name
    
    if searchResult.artistName.isEmpty {
      artistNameLabel.text = "Unkown"
    } else {
      artistNameLabel.text = searchResult.artistName
    }
    
    kindLabel.text = searchResult.kindForDisplay()
    genreLabel.text = searchResult.genre
    
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    formatter.currencyCode = searchResult.currency
    
    let priceText: String
    if searchResult.price == 0 {
      priceText = "Free"
    } else if let text = formatter.stringFromNumber(searchResult.price) {
      priceText = text
    } else {
      priceText = ""
    }
    
    if let url = NSURL(string: searchResult.artworkURL100) {
      downloadTask = artworkImageView.loadImageWithURL(url)
    }
    
    priceButton.setTitle(priceText, forState: .Normal)
  }
  
  deinit {
    print("deinit \(self)")
    downloadTask?.cancel()
  }
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
  func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
    
    return DimmingPresentationController(
      presentedViewController: presented,
      presentingViewController: presenting)
  }
}

extension DetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
    return (touch.view === self.view)
  }
}
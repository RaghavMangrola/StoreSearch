//
//  ViewController.swift
//  StoreSearch
//
//  Created by Raghav Mangrola on 10/13/15.
//  Copyright © 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  
  var observer: AnyObject!
  var landscapeViewController: LandscapeViewController?
  let search = Search()
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  @IBAction func segmentChanged(sender: AnyObject) {
    performSearch()
  }
  
  struct TableViewCellIdentifiers {
    static let searchResultCell = "SearchResultCell"
    static let nothingFoundCell = "NothingFoundCell"
    static let loadingCell = "LoadingCell"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
    tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
    cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
    tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
    cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
    tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
    tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
    tableView.rowHeight = 80
    searchBar.becomeFirstResponder()
    //    listenForContentSizeCategoryNotifications()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowDetail" {
      if case .Results(let list) = search.state {
        let detailViewController = segue.destinationViewController as! DetailViewController
        let indexPath = sender as! NSIndexPath
        let searchResult = list[indexPath.row]
        detailViewController.searchResult = searchResult
      }
    }
  }
  
  func showNetworkError() {
    let alert = UIAlertController(title: "Whoops...", message: "There was an error reading from the iTunes Store. Please try again.", preferredStyle: .Alert)
    
    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alert.addAction(action)
    
    presentViewController(alert, animated: true, completion: nil)
  }
  
  
  override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
    
    switch newCollection.verticalSizeClass {
    case .Compact:
      showLandscapeViewWithCoordinator(coordinator)
    case .Regular, .Unspecified:
      hideLandscapeViewWithCoordinator(coordinator)
    }
  }
  
  func showLandscapeViewWithCoordinator(coordinator: UIViewControllerTransitionCoordinator) {
    precondition(landscapeViewController == nil)
    
    landscapeViewController = storyboard!.instantiateViewControllerWithIdentifier("LandscapeViewController") as? LandscapeViewController
    
    if let controller = landscapeViewController {
      controller.search = search
      controller.view.frame = view.bounds
      controller.view.alpha = 0
      
      view.addSubview(controller.view)
      addChildViewController(controller)
      
      coordinator.animateAlongsideTransition({_ in
        controller.view.alpha = 1
        self.searchBar.resignFirstResponder()
        if self.presentedViewController != nil {
          self.dismissViewControllerAnimated(true, completion: nil)
        }
        }, completion: { _ in
          controller.didMoveToParentViewController(self)
      })
    }
  }
  
  func hideLandscapeViewWithCoordinator(coordinator: UIViewControllerTransitionCoordinator){
    if let controller = landscapeViewController {
      controller.willMoveToParentViewController(nil)
      controller.view.removeFromSuperview()
      controller.removeFromParentViewController()
      landscapeViewController = nil
    }
    
    if self.presentedViewController != nil {
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  
}

extension SearchViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    performSearch()
  }
  
//  func performSearch() {
//    if !searchBar.text!.isEmpty {
//      searchBar.resignFirstResponder()
//      
//      dataTask?.cancel()
//      
//      isLoading = true
//      tableView.reloadData()
//      
//      hasSearched = true
//      searchResults = [SearchResult]()
//      
//      let url = urlWithSearchText(searchBar.text!, category: segmentedControl.selectedSegmentIndex)
//      
//      let session = NSURLSession.sharedSession()
//      
//      dataTask = session.dataTaskWithURL(url, completionHandler: {
//        data, response, error in
//        print("On the main thread? " + (NSThread.currentThread().isMainThread ? "Yes" : "No"))
//        
//        if let error = error where error.code == -999 {
//          return // Search was cancelled
//        } else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
//          if let data = data, dictionary = self.parseJSON(data) {
//            self.searchResults = self.parseDictionary(dictionary)
//            self.searchResults.sortInPlace(<)
//            
//            dispatch_async(dispatch_get_main_queue()) {
//              self.isLoading = false
//              self.tableView.reloadData()
//            }
//            return
//          }
//        } else {
//          print("Success! \(response!)")
//        }
//        
//        dispatch_async(dispatch_get_main_queue()) {
//          self.hasSearched = false
//          self.isLoading = false
//          self.tableView.reloadData()
//          self.showNetworkError()
//        }
//      })
//      dataTask?.resume()
//    }
//  }
  
  func performSearch() {
    if let category = Search.Category(rawValue: segmentedControl.selectedSegmentIndex) {
      search.performSearchForText(searchBar.text!, category: category, completion: { success in
        if !success {
          self.showNetworkError()
        }
        self.landscapeViewController?.searchResultsReceived()
      })
    
      tableView.reloadData()
      searchBar.resignFirstResponder()
    }
  }
  
  func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
    return .TopAttached
  }
  

}

extension SearchViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch search.state {
    case .NotSearchedYet:
      return 0
    case .Loading:
      return 1
    case .NoResults:
      return 1
    case .Results(let list):
      return list.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    switch search.state {
    case .NotSearchedYet:
      fatalError("Should never get here")
      
    case .Loading:
      let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.loadingCell, forIndexPath: indexPath)
      let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
      
    case .NoResults:
      return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath)
      
    case .Results(let list):
      let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell
      let searchResult = list[indexPath.row]
      cell.configureForSearchResult(searchResult)
      return cell
    }
  }
}

extension SearchViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    performSegueWithIdentifier("ShowDetail", sender: indexPath)
  }
  
  func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    switch search.state {
    case .NotSearchedYet, .Loading, .NoResults:
      return nil
    case .Results:
      return indexPath
    }
  }
}
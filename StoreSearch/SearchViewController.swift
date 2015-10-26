//
//  ViewController.swift
//  StoreSearch
//
//  Created by Raghav Mangrola on 10/13/15.
//  Copyright © 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  
  var searchResults = [SearchResult]()
  var hasSearched = false
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  struct TableViewCellIdentifiers {
    static let searchResultCell = "SearchResultCell"
    static let nothingFoundCell = "NothingFoundCell"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
    tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
    cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
    tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
    tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    tableView.rowHeight = 80
    searchBar.becomeFirstResponder()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func urlWithSearchText(searchText: String) -> NSURL {
    let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    let urlString = String(format: "https://itunes.apple.com/search?term=%@", escapedSearchText)
    let url = NSURL(string: urlString)
    return url!
  }
  
  func performStoreRequestWithURL(url: NSURL) -> String? {
    do {
      return try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
    } catch {
      print("Download Error: \(error)", separator: "", terminator: "\n")
      return nil
    }
  }
  
  func showNetworkError() {
    let alert = UIAlertController(title: "Whoops...", message: "There was an error reading from the iTunes Store. Please try again.", preferredStyle: .Alert)
    
    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alert.addAction(action)
    
    presentViewController(alert, animated: true, completion: nil)
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    if !searchBar.text!.isEmpty {
      searchBar.resignFirstResponder()
      
      hasSearched = true
      searchResults = [SearchResult]()
      
      let url = urlWithSearchText(searchBar.text!)
      print("URL: '\(url)'", separator: "", terminator: "\n")
      
      if let jsonString = performStoreRequestWithURL(url) {
        print("Received JSON String '\(jsonString)'", separator: "", terminator: "\n")
        if let dictionary = parseJSON(jsonString) {
          print("Dictionary \(dictionary)", separator: "", terminator: "\n")
          
          tableView.reloadData()
          parseDictionary(dictionary)
          return
        }
      }
      showNetworkError()
    }
  }
  
  func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
    return .TopAttached
  }
  
  func parseJSON(jsonString: String) -> [String: AnyObject]? {
    guard let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
      else { return nil }
    
    do {
      return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
    } catch {
      print("JSON Error: \(error)", separator: "", terminator: "")
      return nil
    }
  }
}

extension SearchViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if !hasSearched {
      return 0
    } else if searchResults.count == 0 {
      return 1
    } else {
      return searchResults.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if searchResults.count == 0 {
      return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath)
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell
      let searchResult = searchResults[indexPath.row]
      cell.nameLabel.text = searchResult.name
      cell.artistNameLabel.text = searchResult.artistName
      return cell
    }
  }
  
  func parseDictionary(dictionary: [String: AnyObject]) {
    guard let array = dictionary["results"] as? [AnyObject] else {
      print("Expected 'results' array", separator: "", terminator: "\n")
      return
    }
    
    for resultDict in array {
      if let resultDict = resultDict as? [String: AnyObject] {
        if let wrapperType = resultDict["wrapperType"] as? String, let kind = resultDict["kind"] as? String {
          print("wrapperType: \(wrapperType), kind \(kind)", separator: "", terminator: "\n")
        }
      }
    }
  }
}

extension SearchViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    if searchResults.count == 0 {
      return nil
    } else {
      return indexPath
    }
  }
}
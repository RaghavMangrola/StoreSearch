//
//  ViewController.swift
//  StoreSearch
//
//  Created by Raghav Mangrola on 10/13/15.
//  Copyright © 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  
  var searchResults = [String]()
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchResults = [String]()
    
    for i in 0...2 {
      searchResults.append(String(format: "Fake Result %d for '%@'", i, searchBar.text!))
    }
    tableView.reloadData()
  }
  
  func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
    return .TopAttached
  }
}

extension SearchViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResults.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cellIdentifier = "SearchResultCell"
    
    var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
    
    if cell == nil {
      cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
    }
    
    cell.textLabel!.text = searchResults[indexPath.row]
    return cell
  }
}

extension SearchViewController: UITableViewDelegate {
  
}
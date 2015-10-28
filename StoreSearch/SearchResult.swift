//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Raghav Mangrola on 10/17/15.
//  Copyright © 2015 Raghav Mangrola. All rights reserved.
//

import Foundation

class SearchResult {
  var name = ""
  var artistName = ""
  var artworkURL60 = ""
  var artworkURL100 = ""
  var storeURL = ""
  var kind = ""
  var currency = ""
  var price = 0.0
  var genre = ""
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
  return lhs.name.localizedStandardCompare(rhs.name) == .OrderedAscending
}
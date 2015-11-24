//
//  Search.swift
//  StoreSearch
//
//  Created by Raghav Mangrola on 11/22/15.
//  Copyright © 2015 Raghav Mangrola. All rights reserved.
//

import Foundation

typealias SearchComplete = (Bool) -> Void

class Search {
  var searchResults = [SearchResult]()
  var hasSearched = false
  var isLoading = false
  
  private var dataTask: NSURLSessionDataTask? = nil
  
  enum Category: Int {
    case All = 0
    case Music = 1
    case Software = 2
    case EBooks = 3
    
    var entityName: String {
      switch self {
      case .All: entityName = ""
      case .Music: entityName = "musicTrack"
      case .Software: entityName = "software"
      case .EBooks: entityName = "ebook"
      }
    }
  }
  
  func performSearchForText(text: String, category: Category, completion: SearchComplete) {
    if !text.isEmpty {
      dataTask?.cancel()
      
      isLoading = true
      hasSearched = true
      searchResults = [SearchResult]()
      
      let url = urlWithSearchText(text, category: category)
      
      let session = NSURLSession.sharedSession()
      
      dataTask = session.dataTaskWithURL(url, completionHandler: {
        data, response, error in
  
        var success = false
        if let error = error where error.code == -999 {
          return // Search was cancelled
        }
        if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200, let data = data, dictionary = self.parseJSON(data) {
            self.searchResults = self.parseDictionary(dictionary)
            self.searchResults.sortInPlace(<)
  
          self.isLoading = false
          success = true
        }
  
        if !success {
          self.hasSearched = false
          self.isLoading = false
        }
      })
      dataTask?.resume()
    }
  }
  
  private func urlWithSearchText(searchText: String, category: Category) -> NSURL {
    
    let entityName = category.entityName
    let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=200&entity=%@", escapedSearchText, entityName)
    let url = NSURL(string: urlString)
    return url!
  }
  
  private func parseJSON(data: NSData) -> [String: AnyObject]? {
    
    do {
      return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
    } catch {
      print("JSON Error: \(error)", separator: "", terminator: "")
      return nil
    }
  }
  
  private func parseDictionary(dictionary: [String: AnyObject]) -> [SearchResult] {
    guard let array = dictionary["results"] as? [AnyObject] else {
      print("Expected 'results' array", separator: "", terminator: "\n")
      return []
    }
    
    var searchResults = [SearchResult]()
    
    for resultDict in array {
      if let resultDict = resultDict as? [String: AnyObject] {
        
        var searchResult: SearchResult?
        
        if let wrapperType = resultDict["wrapperType"] as? String {
          switch wrapperType {
          case "track":
            searchResult = parseTrack(resultDict)
          case "audiobook":
            searchResult = parseAudioBook(resultDict)
          case "software":
            searchResult = parseSoftware(resultDict)
          default:
            break
          }
        } else if let kind = resultDict["kind"] as? String where kind == "ebook" {
          searchResult = parseEBook(resultDict)
        }
        
        if let result = searchResult {
          searchResults.append(result)
        }
      }
    }
    return searchResults
  }
  
  private func parseTrack(dictionary: [String: AnyObject]) -> SearchResult {
    let searchResult = SearchResult()
    
    searchResult.name = dictionary["trackName"] as! String
    searchResult.artistName = dictionary["artistName"] as! String
    searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
    searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
    searchResult.storeURL = dictionary["trackViewUrl"] as! String
    searchResult.kind = dictionary["kind"] as! String
    searchResult.currency = dictionary["currency"] as! String
    
    if let price = dictionary["trackPrice"] as? Double {
      searchResult.price = price
    }
    
    if let genre = dictionary["primaryGenreName"] as? String {
      searchResult.genre = genre
    }
    return searchResult
  }
  
  private func parseAudioBook(dictionary: [String: AnyObject]) -> SearchResult {
    let searchResult = SearchResult()
    
    searchResult.name = dictionary["collectionName"] as! String
    searchResult.artistName = dictionary["artistName"] as! String
    searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
    searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
    searchResult.storeURL = dictionary["collectionViewUrl"] as! String
    searchResult.kind = "audiobook"
    searchResult.currency = dictionary["currency"] as! String
    
    if let price = dictionary["collectionPrice"] as? Double {
      searchResult.price = price
    }
    
    if let genre = dictionary["primaryGenreName"] as? String {
      searchResult.genre = genre
    }
    return searchResult
  }
  
  private func parseSoftware(dictionary: [String: AnyObject]) -> SearchResult {
    let searchResult = SearchResult()
    
    searchResult.name = dictionary["trackName"] as! String
    searchResult.artistName = dictionary["artistName"] as! String
    searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
    searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
    searchResult.storeURL = dictionary["trackViewUrl"] as! String
    searchResult.kind = dictionary["kind"] as! String
    searchResult.currency = dictionary["currency"] as! String
    
    if let price = dictionary["price"] as? Double {
      searchResult.price = price
    }
    
    if let genre = dictionary["primaryGenreName"] as? String {
      searchResult.genre = genre
    }
    return searchResult
  }
  
  private func parseEBook(dictionary: [String: AnyObject]) -> SearchResult {
    let searchResult = SearchResult()
    
    searchResult.name = dictionary["trackName"] as! String
    searchResult.artistName = dictionary["artistName"] as! String
    searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
    searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
    searchResult.storeURL = dictionary["trackViewUrl"] as! String
    searchResult.kind = dictionary["kind"] as! String
    searchResult.currency = dictionary["currency"] as! String
    
    if let price = dictionary["price"] as? Double {
      searchResult.price = price
    }
    
    if let genres: AnyObject = dictionary["genres"] {
      searchResult.genre = (genres as! [String]).joinWithSeparator(", ")
    }
    return searchResult
  }
}
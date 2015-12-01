//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Raghav Mangrola on 10/17/15.
//  Copyright © 2015 Raghav Mangrola. All rights reserved.
//

import Foundation

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
  return lhs.name.localizedStandardCompare(rhs.name) == .OrderedAscending
}

private let displayNamesForKind = [
  "album": NSLocalizedString("Album", comment: "Localized kind: Album"),
  "audiobook": NSLocalizedString("Audio Book", comment: "Localized kind: Audio Book"),
  "book": NSLocalizedString("Book", comment: "Localized kind: Book"),
  "ebook": NSLocalizedString("E-Book", comment: "Localized kind: E-Book"),
  "feature-movie": NSLocalizedString("Movie", comment: "Localized kind: Feature Movie"),
  "music-video": NSLocalizedString("Music Video", comment: "Localized kind: Music Video"),
  "podcast": NSLocalizedString("Podcast", comment: "Localized kind: Podcast"),
  "software": NSLocalizedString("App", comment: "Localized kind: Software"),
  "song": NSLocalizedString("Song", comment: "Localized kind: Song"),
  "tv-episode": NSLocalizedString("TV Episode", comment: "Localized kind: TV Episode"),
]

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
  
  func kindForDisplay() -> String {
    return displayNamesForKind[kind] ?? kind
  }
}

//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Raghav Mangrola on 11/9/15.
//  Copyright © 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
  
  var downloadTask: NSURLSessionDownloadTask?
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var artworkImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    let selectedView = UIView(frame: CGRect.zero)
    selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/355, alpha: 0.5)
    selectedBackgroundView = selectedView
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    downloadTask?.cancel()
    downloadTask = nil
    
    nameLabel.text = nil
    artistNameLabel.text = nil
    artworkImageView.image = nil
    
    nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    artistNameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
  }
  
  func configureForSearchResult(searchResult: SearchResult) {
    nameLabel.text = searchResult.name
    
    if searchResult.artistName.isEmpty {
      artistNameLabel.text = "Uknown"
    } else {
      artistNameLabel.text = String(format: "%@ (%@)", searchResult.artistName, searchResult.kindForDisplay())
    }
    artworkImageView.image = UIImage(named: "Placeholder")
    if let url = NSURL(string: searchResult.artworkURL60) {
      downloadTask = artworkImageView.loadImageWithURL(url)
    }
  }
}

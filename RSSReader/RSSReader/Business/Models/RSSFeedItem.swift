//
//  RSSFeedItem.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 26/10/2020.
//

import Foundation

struct RSSFeedItem {
    let name: String
    let url: String
    
    var isValid: Bool {
        return url.isValidURL
    }
}

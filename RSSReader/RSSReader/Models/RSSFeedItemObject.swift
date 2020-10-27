//
//  RSSFeedItemObject.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 26/10/2020.
//

import Foundation
import RealmSwift

final class RSSFeedItemObject: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var url: String? = nil
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension RSSFeedItemObject {
    convenience init(rssFeedItem: RSSFeedItem) {
        self.init()
        self.id = rssFeedItem.ID
        self.name = rssFeedItem.name
        self.url = rssFeedItem.url
    }
}

//
//  RSSFeedItem.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 26/10/2020.
//

import Foundation
import RealmSwift

struct RSSFeedItem {
    let ID: String
    let name: String
    let url: String
    
    var isValid: Bool {
        return url.isValidURL
    }
}

extension RSSFeedItem {
    init(object: RSSFeedItemObject) {
        self.ID = object.id
        self.name = object.name
        self.url = object.url ?? ""
    }
}

extension RSSFeedItem {
    static let all = FetchRequest<[RSSFeedItem], RSSFeedItemObject>(predicate: nil, sortDescriptors: [SortDescriptor.name], transformer: { $0.map(RSSFeedItem.init) })
}

extension RSSFeedItem {
    static let indexLatest = RSSFeedItem(ID: UUID().uuidString, name: "Index - Najnovije", url: "https://www.index.hr/rss")
    static let indexWorld = RSSFeedItem(ID: UUID().uuidString, name: "Index - World", url: "https://www.index.hr/rss/vijesti-svijet")
    static let sata24Latest = RSSFeedItem(ID: UUID().uuidString, name: "24 sata - Najnovije", url: "https://www.24sata.hr/feeds/najnovije.xml")
    static let sata24Sports = RSSFeedItem(ID: UUID().uuidString, name: "24 sata - Sport", url: "https://www.24sata.hr/feeds/sport.xml")
}

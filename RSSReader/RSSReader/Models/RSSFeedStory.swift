//
//  RSSFeedStory.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 25/10/2020.
//

import Foundation

struct RSSFeedStory {
    let title: String
    var imageStringUrl: String?
    var url: String?
}

extension RSSFeedStory {
    static let storyOne = RSSFeedStory(title: "Test story 1", imageStringUrl: "stringUrl", url: "url")
    static let storyTwo = RSSFeedStory(title: "Test story 2", imageStringUrl: "stringUrl", url: "url")
    static let storyThree = RSSFeedStory(title: "Test story 3", imageStringUrl: "stringUrl", url: "url")
}

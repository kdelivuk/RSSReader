//
//  RSSStoriesVM.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 22/10/2020.
//

import FeedKit
import RxSwift
import RxCocoa
import SwiftSoup

protocol RSSStoriesVMType {
    var viewModelsDriver: Driver<[Item]> { get }
}

struct Item {
    let title: String
    var imageStringUrl: String?
    var url: String?
}

extension String {

  func parseStrring(start: String, to: String) -> String? {

    guard let startIndex = self.range(of: start)?.upperBound, let endIndex = self.range(of: to)?.lowerBound else {
        return nil
    }

    return String(self[startIndex..<endIndex])
  }
}

final class RSSStoriesVM {
    
    var viewModelsDriver: SharedSequence<DriverSharingStrategy, [Item]> {
        return viewModelsSubject.asDriver(onErrorJustReturn: [])
    }
    
    private let rssManager: RSSManager
    private let disposeBag = DisposeBag()
    private let viewModelsSubject = BehaviorSubject<[Item]>(value: [])
    
    init(rssFeedItem: RSSFeedItem, rssManager: RSSManager) {
        self.rssManager = rssManager
        
        self.rssManager
            .fetchRSSStories(for: URL(string: "https://www.index.hr/rss")!)
            .map({ (feed) -> [Item] in
                return feed.items?.map { item -> Item in
                    do {
                        if let html = item.description {
                            let doc: Document = try SwiftSoup.parse(html)
                            if let imageURL = try doc.select("img").first()?.attr("src") {
                                return Item(title: item.title ?? "Bez naslova", imageStringUrl: imageURL, url: item.link)
                            }
                        }
                    } catch Exception.Error(let type, let message) {
                        print(type, message)
                        return Item(title: item.title ?? "Bez naslova", imageStringUrl: nil, url: item.link)
                    } catch {
                        print("RSSStoriesVM - Error parsing HTML.")
                    }
                    return Item(title: item.title ?? "Bez naslova", imageStringUrl: nil, url: item.link)
                } ?? []
            })
            .subscribe(viewModelsSubject)
            .disposed(by: disposeBag)
    }
}

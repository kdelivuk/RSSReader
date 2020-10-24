//
//  RSSManager.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 22/10/2020.
//

import RxSwift
import FeedKit
import SwiftSoup
import RxRelay

final class RSSManager {
    
    private var rssFeedItems: BehaviorRelay<[RSSFeedItem]> = .init(value: [])
    var rssFeedItemObservable: Observable<[RSSFeedItem]> {
        return rssFeedItems.asObservable()
    }
    
    func item(at index: Int) -> RSSFeedItem {
        return rssFeedItems.value[index]
    }
    
    func addRSSFeedItem(item: RSSFeedItem) {
        var newItems = rssFeedItems.value
        newItems.append(item)
        rssFeedItems.accept(newItems)
    }
    
    func removeRSSFeedItem(at index: Int) {
        let itemToRemove = item(at: index)
        let newItems = rssFeedItems.value.filter({$0.name != itemToRemove.name})
        rssFeedItems.accept(newItems)
    }
    
    func fetchRSSStories(for url: URL) -> Observable<RSSFeed> {
        return  Observable.create { observer in
            let parser = FeedParser(URL: url)
            parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let feed):
                        print(feed)
                        switch feed {
                        case let .atom(feed):
                            break
                        case let .rss(feed):
                            observer.onNext(feed)
                        case let .json(feed):
                            break
                        }
                    case .failure(let error):
                        print(error)
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }

}

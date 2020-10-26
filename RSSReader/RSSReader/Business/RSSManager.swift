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
    
    // MARK: - Private properties
    
    private let rssFeedStories: BehaviorRelay<[RSSFeedStory]> = .init(value: [])
    private let rssFeedItems: BehaviorRelay<[RSSFeedItem]> = .init(value: [])
    
    // MARK: - Public properties
    
    lazy var rssFeedItemObservable: Observable<[RSSFeedItem]> = {
        return rssFeedItems.asObservable()
    }()
    
    // MARK: - Public methods
    
    func story(at index: Int) -> RSSFeedStory {
        return rssFeedStories.value[index]
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
    
    func fetchRSSStories(for url: URL) -> Observable<[RSSFeedStory]> {
        return  Observable.create { observer in
            let parser = FeedParser(URL: url)
            parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let feed):
                        print(feed)
                        switch feed {
                        case let .rss(feed):
                            let parsedFeed = self.parseItemsFeed(feed: feed)
                            self.rssFeedStories.accept(parsedFeed)
                            observer.onNext(parsedFeed)
                        default:
                            let error = GeneralError(type: .api, description: "Parsing error.")
                            observer.onError(error)
                            break
                        }
                    case .failure(let error):

                        observer.onError(error)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: - Private methods
    
    private func parseItemsFeed(feed: RSSFeed) -> [RSSFeedStory] {
        return feed.items?.map { item -> RSSFeedStory in
            do {
                if let html = item.description {
                    let doc: Document = try SwiftSoup.parse(html)
                    if let imageURL = try doc.select("img").first()?.attr("src") {
                        return RSSFeedStory(title: item.title ?? "Bez naslova", imageStringUrl: imageURL, url: item.link)
                    }
                }
            } catch Exception.Error(let type, let message) {
                print(type, message)
                return RSSFeedStory(title: item.title ?? "Bez naslova", imageStringUrl: nil, url: item.link)
            } catch {
                print("RSSStoriesVM - Error parsing HTML.")
            }
            return RSSFeedStory(title: item.title ?? "Bez naslova", imageStringUrl: nil, url: item.link)
        } ?? []
    }
}

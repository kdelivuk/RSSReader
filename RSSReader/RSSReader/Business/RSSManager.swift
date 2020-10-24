//
//  RSSManager.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 22/10/2020.
//

import RxSwift
import FeedKit
import SwiftSoup

struct Feed {
    
}

final class RSSManager {
    
    func fetchRSSFeed(for url: URL) -> Observable<RSSFeed> {
        return  Observable.create { observer in
//            let parser = FeedParser(URL:
            if let htmlString = try? String(contentsOf: url, encoding: .ascii) {
//                if let doc: Document = try? SwiftSoup.parse(htmlString) {
//                    let v = try! doc.getAllElements().select("script").first()
//                    print(v)
//                }
                if let result = htmlString.parseStrring(start: "window.flatpageData = ", to: "//-->") { // start from {" to "}
                    let data = Data(result.utf8)
//                    let json = try! JSONSerialization.jsonObject(with: data, options: [])
                    print(result.utf8)
                }
            }
            return Disposables.create()
        }
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

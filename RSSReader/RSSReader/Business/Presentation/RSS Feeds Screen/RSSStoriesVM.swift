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
    var viewModelsDriver: Driver<[RSSFeedStory]> { get }
}

final class RSSStoriesVM {
    
    var viewModelsDriver: SharedSequence<DriverSharingStrategy, [RSSFeedStory]> {
        return viewModelsSubject.asDriver(onErrorJustReturn: [])
    }
    
    var itemSelectedSubject = PublishSubject<RSSFeedStory>()
    
    private let rssManager: RSSManager
    private let disposeBag = DisposeBag()
    private let viewModelsSubject = BehaviorSubject<[RSSFeedStory]>(value: [])
    
    init(rssFeedItem: RSSFeedItem, rssManager: RSSManager) {
        self.rssManager = rssManager
        
        self.rssManager
            .fetchRSSStories(for: URL(string: "https://www.index.hr/rss")!)
            .subscribe(viewModelsSubject)
            .disposed(by: disposeBag)
    }
    
    func onItemSelected(at indexPath: IndexPath) {
        let item = rssManager.story(at: indexPath.row)
        itemSelectedSubject.onNext(item)
    }
}

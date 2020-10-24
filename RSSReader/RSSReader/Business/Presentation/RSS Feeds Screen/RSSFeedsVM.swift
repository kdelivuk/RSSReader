//
//  RSSFeedsVM.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 23/10/2020.
//

import RxSwift
import RxCocoa

struct RSSFeedItem {
    let name: String
    let url: String
}


class RSSFeedsVM {
    
    var viewModelsDriver: SharedSequence<DriverSharingStrategy, [RSSFeedItem]> {
        return viewModelsSubject.asDriver(onErrorJustReturn: [])
    }
    
    var itemSelectedSubject = PublishSubject<RSSFeedItem>()
    
    private let rssManager: RSSManager
    private let disposeBag = DisposeBag()
    private let viewModelsSubject = BehaviorSubject<[RSSFeedItem]>(value: [])
    
    init(rssManager: RSSManager) {
        self.rssManager = rssManager
        
        self.rssManager
            .rssFeedItemObservable
            .subscribe(viewModelsSubject)
            .disposed(by: disposeBag)
    }
    
    func addRSSFeedItem(item: RSSFeedItem) {
        rssManager.addRSSFeedItem(item: item)
    }
    
    func removeRSSFeedItem(at indexPath: IndexPath) {
        rssManager.removeRSSFeedItem(at: indexPath.row)
    }
    
    func onItemSelected(at indexPath: IndexPath) {
        let item = rssManager.item(at: indexPath.row)
        itemSelectedSubject.onNext(item)
    }
}

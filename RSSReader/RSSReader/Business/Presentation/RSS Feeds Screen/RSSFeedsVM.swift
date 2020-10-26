//
//  RSSFeedsVM.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 23/10/2020.
//

import RxSwift
import RxCocoa

protocol RSSFeedsVMType {
    var viewModelsDriver: SharedSequence<DriverSharingStrategy, [RSSFeedItem]> { get }
    
    func addRSSFeedItem(item: RSSFeedItem)
    func removeRSSFeedItem(at indexPath: IndexPath)
    func onItemSelected(at indexPath: IndexPath)
}

class RSSFeedsVM: RSSFeedsVMType {
    
    // MARK: - Coordinator actions
    
    var itemSelectedSubject = PublishSubject<RSSFeedItem>()
    
    // MARK: - Private properties
    
    private let rssManager: RSSManager
    private let disposeBag = DisposeBag()
    private let viewModelsSubject = BehaviorSubject<[RSSFeedItem]>(value: [])
    
    // MARK: - Public properties
    
    lazy var viewModelsDriver: SharedSequence<DriverSharingStrategy, [RSSFeedItem]> = {
        return viewModelsSubject.asDriver(onErrorJustReturn: [])
    }()
    
    // MARK: - Class lifecycle
    
    init(rssManager: RSSManager) {
        self.rssManager = rssManager
        
        self.rssManager
            .rssFeedItemObservable
            .subscribe(viewModelsSubject)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public properties
    
    func addRSSFeedItem(item: RSSFeedItem) {
        rssManager.addRSSFeedItem(item: item)
    }
    
    func removeRSSFeedItem(at indexPath: IndexPath) {
        if isValid(at: indexPath) {
            rssManager.removeRSSFeedItem(at: indexPath.row)
        } else {
            // TODO: -
        }
    }
    
    func onItemSelected(at indexPath: IndexPath) {
        let item = rssManager.item(at: indexPath.row)
        itemSelectedSubject.onNext(item)
    }
    
    // MARK: - Private properties
    
    private func isValid(at indexPath: IndexPath) -> Bool {
        return rssManager.item(at: indexPath.row).isValid
    }
}

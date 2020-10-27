//
//  RSSStoriesVM.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 22/10/2020.
//

import RxSwift
import RxCocoa

protocol RSSStoriesVMType {
    var viewModelsDriver: Driver<[RSSFeedStory]> { get }
    
    func onItemSelected(at indexPath: IndexPath)
}

final class RSSStoriesVM: RSSStoriesVMType {
    
    // MARK: - Coordinator actions
    
    var itemSelectedSubject = PublishSubject<RSSFeedStory>()
    
    // MARK: - Public properties
    
    lazy var viewModelsDriver: SharedSequence<DriverSharingStrategy, [RSSFeedStory]> = {
        return viewModelsSubject.asDriver(onErrorJustReturn: [])
    }()
    
    // MARK: - Private properties
    
    private let rssManager: RSSManagerType
    private let disposeBag = DisposeBag()
    private let viewModelsSubject = BehaviorSubject<[RSSFeedStory]>(value: [])
    
    // MARK: - Class lifecycle
    
    init(rssFeedItem: RSSFeedItem, rssManager: RSSManagerType) {
        self.rssManager = rssManager
        
        guard let url =  URL(string: rssFeedItem.url) else {
            let error = GeneralError(type: .parsing, description: "Cannot parse given url.")
            viewModelsSubject.onError(error)
            return
        }
        
        self.rssManager
            .fetchRSSStories(for: url)
            .subscribe(viewModelsSubject)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public properties
    
    func onItemSelected(at indexPath: IndexPath) {
        let item = rssManager.story(at: indexPath.row)
        itemSelectedSubject.onNext(item)
    }
}

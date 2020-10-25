//
//  AppCoordinator.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 24/10/2020.
//

import UIKit
import RxSwift

final class AppCoordinator: Coordinator {
    
    private let rssManager = RSSManager()
    private let disposeBag = DisposeBag()
    
    init(in window: UIWindow) {
        super.init()
        setRSSFeedsListScreen(in: window)
    }
    
    func setRSSFeedsListScreen(in window: UIWindow) {
        let rssFeedsVM = RSSFeedsVM(rssManager: rssManager)
        let rssFeedsVC = RSSFeedsVC(viewModel: rssFeedsVM)
        let rssFeedsNC = UINavigationController(rootViewController: rssFeedsVC)
        
        rssFeedsVM
            .itemSelectedSubject
            .subscribe { (item) in
                self.pushRSSFeedDetailsScreen(rssFeedItem: item, in: rssFeedsNC)
        }.disposed(by: disposeBag)

        window.rootViewController = rssFeedsNC
    }
    
    func pushRSSFeedDetailsScreen(rssFeedItem: RSSFeedItem, in navigationController: UINavigationController) {
        let rssStoriesVM = RSSStoriesVM(rssFeedItem: rssFeedItem, rssManager: rssManager)
        let rssStoriesVC = RSSStoriesVC(viewModel: rssStoriesVM)
        
        navigationController.pushViewController(rssStoriesVC, animated: true)
    }
}

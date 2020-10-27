//
//  AppCoordinator.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 24/10/2020.
//

import UIKit
import RxSwift

final class AppCoordinator: Coordinator {
    
    lazy private var rssManager: RSSManagerType = {
        let database = Database()
        let manager = RSSManager(database: database)
        return manager
    }()
    
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
            .subscribe { [unowned self] item in
                self.pushRSSFeedDetailsScreen(rssFeedItem: item, in: rssFeedsNC)
            } onError: { [unowned self] error in
                self.pushAlert(with: (error as? GeneralError)?.description ?? "", in: rssFeedsNC)
            }.disposed(by: disposeBag)

        window.rootViewController = rssFeedsNC
    }
    
    func pushRSSFeedDetailsScreen(rssFeedItem: RSSFeedItem, in navigationController: UINavigationController) {
        let rssStoriesVM = RSSStoriesVM(rssFeedItem: rssFeedItem, rssManager: rssManager)
        let rssStoriesVC = RSSStoriesVC(viewModel: rssStoriesVM)
        
        rssStoriesVM
            .itemSelectedSubject
            .subscribe { [unowned self] item in
                self.pushWebViewScreen(rssFeedItem: item, in: navigationController)
        }.disposed(by: disposeBag)
        
        navigationController.pushViewController(rssStoriesVC, animated: true)
    }
    
    func pushWebViewScreen(rssFeedItem: RSSFeedStory, in navigationController: UINavigationController) {
        let wkWebVC = WKWebVC(stringURL: rssFeedItem.url!)
        navigationController.pushViewController(wkWebVC, animated: true)
    }
    
    func pushAlert(with error: String, in navigationController: UINavigationController) {
        let actions: [AlertAction] = [
            .action(title: "OK")
        ]

        UIAlertController
            .presentForError(in: navigationController, title: "Error", message: error, style: .alert, actions: actions)
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
    }
}

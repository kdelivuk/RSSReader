//
//  RSSFeedsVC.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 23/10/2020.
//

import UIKit
import RxSwift

final class RSSFeedsVC: UIViewController {
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bbb = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(sgagsa(sender:)))
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = bbb
        
    }
    
    @objc
    private func sgagsa(sender: UIBarButtonItem) {
        let actions: [UIAlertController.AlertAction] = [
            .action(title: "Cancel", style: .destructive),
            .action(title: "OK")
        ]

        UIAlertController
            .present(in: self, title: "Alert", message: "message", style: .alert, actions: actions)
            .subscribe(onNext: { buttonIndex in
                print(buttonIndex)
            })
            .disposed(by: disposeBag)
    }
}
extension UIAlertController {

    struct AlertAction {
        var title: String?
        var style: UIAlertAction.Style

        static func action(title: String?, style: UIAlertAction.Style = .default) -> AlertAction {
            return AlertAction(title: title, style: style)
        }
    }

    static func present(
        in viewController: UIViewController,
        title: String?,
        message: String?,
        style: UIAlertController.Style,
        actions: [AlertAction])
        -> Observable<[String]>
    {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)

            alertController.addTextField { textField in
                textField.placeholder = "Enter name of rss feed"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Enter url"
            }
            
            actions.enumerated().forEach { index, action in
                let action = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(alertController.textFields?.map { $0.text ?? "" } ?? [])
                    observer.onCompleted()
                }
                alertController.addAction(action)
            }

            viewController.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }

    }

}

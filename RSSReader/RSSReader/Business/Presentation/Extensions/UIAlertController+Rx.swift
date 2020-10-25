//
//  UIAlertController+Rx.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 24/10/2020.
//

import UIKit
import RxSwift

struct AlertAction {
    var title: String?
    var style: UIAlertAction.Style

    static func action(title: String?, style: UIAlertAction.Style = .default) -> AlertAction {
        return AlertAction(title: title, style: style)
    }
}

extension UIAlertController {
    static func present(in viewController: UIViewController, title: String?, message: String?, style: UIAlertController.Style, actions: [AlertAction]) -> Observable<[String]> {
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
                    if action.style != .destructive {
                        observer.onNext(alertController.textFields?.map { $0.text ?? "" } ?? [])
                    }
                    observer.onCompleted()
                }
                alertController.addAction(action)
            }

            viewController.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
    }
}

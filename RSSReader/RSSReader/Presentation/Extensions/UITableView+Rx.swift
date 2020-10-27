//
//  UITableView+Rx.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 27/10/2020.
//

import Foundation

extension Reactive where Base: UITableView {
    func isEmpty(message: String) -> Binder<Bool> {
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.configureForEmptyState(with: message)
            } else {
                tableView.removeEmptyState()
            }
        }
    }
}

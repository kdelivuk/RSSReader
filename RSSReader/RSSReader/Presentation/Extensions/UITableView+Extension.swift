//
//  UITableView+Extension.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 27/10/2020.
//

import UIKit

extension UITableView {
    func configureForEmptyState(with message: String) {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = message
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        self.isScrollEnabled = false
        self.backgroundView = label
        self.separatorStyle = .none
    }

    func removeEmptyState() {
        self.isScrollEnabled = true
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

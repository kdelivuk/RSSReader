//
//  RSSFeedsVC.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 23/10/2020.
//

import UIKit
import RxSwift

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

final class RSSFeedsVC: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: RSSFeedsVM
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 120
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tv
    }()
    
    // MARK: - Class lifecycle
    
    init(viewModel: RSSFeedsVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bindTableView()
        addSubviews()
        addBarButtonItems()
        setupConstraints()
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        view.addSubview(self.tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
    
    private func addBarButtonItems() {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonItemAction(sender:)))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func bindTableView() {
        viewModel
            .viewModelsDriver
            .drive(tableView.rx.items) { tableView, row, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
                cell.textLabel?.text = item.name
                cell.textLabel?.textColor = item.isValid ? .black : .red
                return cell
            }.disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                if self.viewModel.isValid(at: indexPath) {
                    self.viewModel.removeRSSFeedItem(at:  indexPath)
                } else {
                    // TODO: -
                }
            })
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .itemSelected
            .subscribe { indexPath in
                self.viewModel.onItemSelected(at: indexPath)
            }.disposed(by: disposeBag)

    }
    
    @objc
    private func barButtonItemAction(sender: UIBarButtonItem) {
        let actions: [AlertAction] = [
            .action(title: "Cancel", style: .destructive),
            .action(title: "OK")
        ]

        UIAlertController
            .present(in: self, title: "Alert", message: "message", style: .alert, actions: actions)
            .subscribe(onNext: { items in
                self.viewModel.addRSSFeedItem(item: RSSFeedItem(name: items.first!, url: items.last!))
            })
            .disposed(by: disposeBag)
    }
}

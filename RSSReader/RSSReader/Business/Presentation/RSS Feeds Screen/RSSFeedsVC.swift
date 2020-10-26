//
//  RSSFeedsVC.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 23/10/2020.
//

import UIKit
import RxSwift

final class RSSFeedsVC: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: RSSFeedsVMType
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 120
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tv
    }()
    
    // MARK: - Class lifecycle
    
    init(viewModel: RSSFeedsVMType) {
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
                guard let self = self else { return }
                self.viewModel.removeRSSFeedItem(at:  indexPath)
            })
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .itemSelected
            .subscribe { indexPath in
                self.viewModel.onItemSelected(at: indexPath)
            }.disposed(by: disposeBag)
    }
    
    // MARK: - Button callbacks
    
    @objc
    private func barButtonItemAction(sender: UIBarButtonItem) {
        let actions: [AlertAction] = [
            .action(title: "Cancel", style: .destructive),
            .action(title: "OK")
        ]

        UIAlertController
            .present(in: self, title: "Add new RSS feed provider", message: "Add new RSS feed provider", style: .alert, actions: actions)
            .subscribe(onNext: { items in
                self.viewModel.addRSSFeedItem(item: RSSFeedItem(name: items.first!, url: items.last!))
            })
            .disposed(by: disposeBag)
    }
}

//
//  RSSStoriesVC.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 22/10/2020.
//

import UIKit
import SnapKit
import RxSwift

final class RSSStoriesVC: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: RSSStoriesVMType
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 120
        tv.register(ImageViewTitleLabelCell.self, forCellReuseIdentifier: "ImageViewTitleLabelCell")
        return tv
    }()

    // MARK: - Class lifecycle
    
    init(viewModel: RSSStoriesVMType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bindTableView()
        addSubviews()
        setupConstraints()
    }
    
    // MARK: - Private methods
    
    private func configureView() {
        view.backgroundColor = .white
        title = "RSS Stories"
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
    
    private func bindTableView() {
        viewModel
            .viewModelsDriver
            .drive(tableView.rx.items) { tableView, row, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewTitleLabelCell") as! ImageViewTitleLabelCell
                cell.configure(with: item)
                return cell
            }.disposed(by: disposeBag)
        
        tableView
            .rx
            .itemSelected
            .subscribe { indexPath in
                self.viewModel.onItemSelected(at: indexPath)
            }.disposed(by: disposeBag)
        
        
        let isEmpty = tableView.rx.isEmpty(message: "There are no stories for this RSS feed at the moment.")
        viewModel
            .viewModelsDriver
            .asObservable()
            .map { $0.count <= 0 }
            .distinctUntilChanged()
            .bind(to: isEmpty)
            .disposed(by: disposeBag)

    }
}

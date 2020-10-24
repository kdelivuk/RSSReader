//
//  RSSStoriesVC.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 22/10/2020.
//

import UIKit
import SnapKit
import RxRelay
import RxSwift
import FeedKit
import SwiftSoup
import Kingfisher

final class RSSStoriesVC: UIViewController {
    
    var viewModel = RSSStoriesVM(rssManager: RSSManager())
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 120
        tv.register(ImageViewTitleLabelCell.self, forCellReuseIdentifier: "ImageViewTitleLabelCell")
        return tv
    }()

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        bindTableView()
        setupConstraints()
    }
    
    func bindTableView() {
        viewModel
            .viewModelsDriver
            .drive(tableView.rx.items) { tableView, row, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageViewTitleLabelCell") as! ImageViewTitleLabelCell
                cell.configure(with: item)
                
                return cell
            }.disposed(by: disposeBag)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
}

final class ImageViewTitleLabelCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    let leftImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let hStackView = UIStackView(arrangedSubviews: [leftImageView, titleLabel])
        hStackView.axis = .horizontal
        hStackView.alignment = .fill
        hStackView.spacing = 10
        
        let vStackView = UIStackView(arrangedSubviews: [hStackView])
        vStackView.axis = .vertical
        
        contentView.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(15)
        }
        
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.numberOfLines = 0
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.snp.makeConstraints {
            $0.size.equalTo(100)
        }
    }
    
    func configure(with item: Item) {
        titleLabel.text = item.title
        if item.imageStringUrl != nil {
            leftImageView.kf.setImage(with: URL(string: item.imageStringUrl!)!)
        }
    }
}

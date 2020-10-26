//
//  ImageViewTitleLabelCell.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 26/10/2020.
//

import UIKit

final class ImageViewTitleLabelCell: UITableViewCell {
    
    // MARK: - Private properties
    
    private let titleLabel = UILabel()
    private let leftImageView = UIImageView()
    
    // MARK: - Class lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
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
    
    // MARK: - Public methods
    
    func configure(with item: RSSFeedStory) {
        titleLabel.text = item.title
        leftImageView.isHidden = item.imageStringUrl == nil
        if item.imageStringUrl != nil {
            leftImageView.kf.setImage(with: URL(string: item.imageStringUrl!)!)
        }
    }
}

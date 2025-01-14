//
//  WordBookCollectionCell.swift
//  SwiftRun
//
//  Created by 황석현 on 1/8/25.
//

import UIKit
import SnapKit

class WordBookCollectionCell: UICollectionViewCell {
    
    static let identifier = String(describing: WordBookCollectionCell.self)
    
    private let wordBookTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "SRBlue400")
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor(named: "SRBlue400")?.cgColor
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(wordBookTitle)
    }
    
    private func setupConstraints() {
        wordBookTitle.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    func configure(with item: Category) {
        wordBookTitle.text = item.name.isEmpty ? "Unnamed Category" : item.name
    }
}

@available(iOS 17.0, *)
#Preview("WordBookCollectionCell") {
    WordBookCollectionCell()
}

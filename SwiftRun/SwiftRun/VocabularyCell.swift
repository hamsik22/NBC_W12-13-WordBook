//
//  VocabularyCell.swift
//  SwiftRun
//
//  Created by 반성준 on 1/9/25.
//


import UIKit
import SnapKit

class VocabularyCell: UITableViewCell {
    let nameLabel = UILabel()
    let definitionLabel = UILabel()
    let memorizeTag = UIButton()

    var onMemorizeToggle: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Name Label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(nameLabel)

        // Definition Label
        definitionLabel.font = UIFont.systemFont(ofSize: 14)
        definitionLabel.textColor = .darkGray
        contentView.addSubview(definitionLabel)

        // Memorize Tag
        memorizeTag.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        memorizeTag.layer.cornerRadius = 8
        memorizeTag.backgroundColor = .systemGray
        memorizeTag.addTarget(self, action: #selector(toggleMemorize), for: .touchUpInside)
        contentView.addSubview(memorizeTag)

        // SnapKit Constraints
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
        }

        definitionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        memorizeTag.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(nameLabel)
        }
    }

    @objc private func toggleMemorize() {
        onMemorizeToggle?()
    }
}

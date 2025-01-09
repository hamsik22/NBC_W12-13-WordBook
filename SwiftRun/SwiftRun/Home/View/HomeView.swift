//
//  HomeView.swift
//  SwiftRun
//
//  Created by 황석현 on 1/8/25.
//

import UIKit
import SnapKit

class HomeView: UIView {
    
    private let appTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "SwiftRun"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        return button
    }()
    private let profile = ProfileView()
    private let wordBookListLabel: UILabel = {
        let label = UILabel()
        label.text = "단어장 목록"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private(set) var wordBookCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 170, height: 100)
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
extension HomeView {
    private func setup() {
        [   appTitleLabel, settingsButton,
            profile,
            wordBookListLabel,
            wordBookCollectionView
        ].forEach{ addSubview($0) }
        
        appTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(50)
            make.width.equalTo(150)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.size.equalTo(50)
        }
        
        profile.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(appTitleLabel.snp.bottom).offset(30)
            make.height.equalTo(100)
        }
        
        wordBookListLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(profile.snp.bottom).offset(40)
        }
        
        wordBookCollectionView.snp.makeConstraints { make in
            make.top.equalTo(wordBookListLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        wordBookCollectionView.register(WordBookCollectionCell.self, forCellWithReuseIdentifier: WordBookCollectionCell.identifier)
    }
    
}

@available(iOS 17.0, *)
#Preview("HomeViewController") {
    HomeViewController()
}

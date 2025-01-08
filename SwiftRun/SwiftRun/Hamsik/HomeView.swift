//
//  HomeView.swift
//  SwiftRun
//
//  Created by 황석현 on 1/8/25.
//

import UIKit
import SnapKit

class HomeView: UIView {
    
    let appTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "SwiftRun"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        return button
    }()
    let profile: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    let wordBookListLabel: UILabel = {
        let label = UILabel()
        label.text = "단어장 목록"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    let wordBookCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .blue
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
        [
            appTitleLabel, settingsButton,
            profile,
            wordBookListLabel,
            wordBookCollectionView
        ].forEach{ addSubview($0) }
        
        appTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(50)
            make.width.equalTo(150)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(50)
        }
        
        profile.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(appTitleLabel.snp.bottom).offset(30)
            make.height.equalTo(150)
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
    }
}

@available(iOS 17.0, *)
#Preview {
    HomeView()
}

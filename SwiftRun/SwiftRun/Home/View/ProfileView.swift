//
//  ProfileView.swift
//  SwiftRun
//
//  Created by 황석현 on 1/8/25.
//

import UIKit
import SnapKit

class ProfileView: UIView {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "황석현"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private let progressPercentLabel: UILabel = {
        let label = UILabel()
        label.text = "50%"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.backgroundColor = .blue
        return label
    }()
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "1/333" // 추후엔 \(currentCount) / \(totalCount) 식으로 개발
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    private let editProfileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.layer.borderColor = UIColor.systemBlue.cgColor
        return button
    }()
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = 0.5 // 초기 게이지 값 (0.0 ~ 1.0)
        progressView.trackTintColor = .lightGray // 배경색
        progressView.progressTintColor = .systemBlue // 게이지 색상
        return progressView
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
extension ProfileView {
    private func setup() {
        [
            profileImageView,
            nameLabel, editProfileButton,
            progressPercentLabel, countLabel,
            progressBar
        ].forEach { addSubview($0) }
        
        profileImageView.snp.makeConstraints{ make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(100)
            make.bottom.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.top.equalToSuperview()
            make.height.equalTo(30)
        }
        editProfileButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        progressPercentLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(progressPercentLabel.snp.trailing).offset(5)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        progressBar.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(10)
        }
    }
}

@available(iOS 17.0, *)
#Preview("HomeViewController") {
    HomeViewController()
}

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
        imageView.image = UIImage(named: "profile")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "황석현"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    private let progressPercentLabel: UILabel = {
        let label = UILabel()
        label.text = "50%"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = UIColor(named: "SRBlue500")
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "1 / 333" // 추후엔 \(currentCount) / \(totalCount) 식으로 개발
        label.font = .systemFont(ofSize: 12, weight: .bold)
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
        progressView.progress = 0.5
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .systemBlue
        progressView.layer.cornerRadius = 5
        progressView.layer.masksToBounds = true
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
            make.height.equalTo(30)
        }
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(progressPercentLabel.snp.trailing).offset(5)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        progressBar.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(15)
        }
    }
    func configure(name: String, count: Int) {
        self.nameLabel.text = name
        self.progressPercentLabel.text = "\((count / 333) * 100) %"
        self.countLabel.text = "\(count) / 333"
        self.progressBar.progress = Float(Double(count) / 333)
    }
}

@available(iOS 17.0, *)
#Preview("HomeViewController") {
    HomeViewController()
}

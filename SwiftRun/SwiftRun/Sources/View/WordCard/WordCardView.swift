//
//  WordCardView.swift
//  SwiftRun
//
//  Created by 김하민 on 1/8/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WordCardView: UIView {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let memorizedButton: MemorizedButton = {
        let button = MemorizedButton()
        
        button.backgroundColor = .srBlue600Primary
        button.titleLabel?.text = "외웠어요"
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .thin)
        
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "asdf123"
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.textColor = .sr900Black
        
        return label
    }()
    
    private let subnameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.text = "asdf123"
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.textColor = .sr700Gray
        
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "asdf123"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.textColor = .sr900Black
        
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .srBlue600Primary
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.tintColor = .sr100White
        
        return button
    }()
    
    // MARK: - UI StackView
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            memorizedButton, nameLabel, subnameLabel, detailsLabel
        ])
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        return stackView
    }()
    
    // MARK: - Initializers
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        addSubview(nextButton)
        
        backgroundColor = .sr100White
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 지금은 더미 뷰모델의 첫번째를 갖고오지만 나중엔 수정해야함.
    func bind(to viewModel: DummyViewModel) {
        viewModel.currentCardSubject.observe(on: MainScheduler.instance)
            .subscribe(
                onNext:
                    { [weak self] word in
                        self?.nameLabel.text = word.name
                        self?.subnameLabel.text = word.subname
                        self?.detailsLabel.text = word.details
                    }
            ).disposed(by: disposeBag)
        
        viewModel.didMemorize.observe(on: MainScheduler.instance)
            .subscribe(
                onNext:
                    { [weak self] bool in
                        self?.memorizedButton.updateButton(bool)
                    }
            ).disposed(by: disposeBag)
        
        memorizedButton.rx.tap
            .subscribe(onNext: { viewModel.memorizedButtonTapped() })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: { viewModel.nextButtonTapped() })
            .disposed(by: disposeBag)
    }
    
    private func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalToSuperview().dividedBy(3)
            make.centerY.equalToSuperview()
        }
        
        memorizedButton.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}

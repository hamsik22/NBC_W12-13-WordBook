//
//  SettingView.swift
//  SwiftRun
//
//  Created by 황석현 on 1/13/25.
//

import UIKit
import SnapKit

class SettingView: UIView {
    private let appearanceIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "moon.circle")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBackground
        return imageView
    }()
    private let appearanceLabel: UILabel = {
        let label = UILabel()
        label.text = "라이트/다크 모드"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.snp.makeConstraints { make in make.height.equalTo(50)}
        return label
    }()
    
    let themeToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        return toggle
    }()
    private let privacyIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lock.circle")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()
     let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("개인정보 관리정책", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.snp.makeConstraints { make in make.height.equalTo(50)}
        return button
    }()
    private let helpIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "info.circle")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()
     let helpButton: UIButton = {
        let button = UIButton()
        button.setTitle("도움이 필요하신가요?", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.snp.makeConstraints { make in make.height.equalTo(50)}
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical       // 세로 방향
        stackView.spacing = 0            // 간격 없음
        stackView.alignment = .fill      // 각 뷰의 크기 맞춤
        stackView.distribution = .fill   // 간격 균등 분배 제거
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingView {
    private func setup() {
        setTintColor()
        // 라이트/다크모드의 스택뷰
        let appearanceStack = UIStackView()
        appearanceStack.axis = .horizontal
        appearanceStack.alignment = .center
        appearanceStack.distribution = .equalSpacing
        appearanceStack.spacing = 10
        // 아이콘과 레이블의 스택뷰
        let appearanceLabelwithIcon = UIStackView()
        appearanceLabelwithIcon.axis = .horizontal
        appearanceLabelwithIcon.spacing = 5
        [appearanceIcon, appearanceLabel].forEach{ appearanceLabelwithIcon.addArrangedSubview($0)}
        // 라이트/다크모드의 스택뷰에 서브뷰 추가
        [appearanceLabelwithIcon, themeToggle].forEach { appearanceStack.addArrangedSubview($0) }
        
        // 개인정보 스택뷰
        let privacyStack = UIStackView()
        appearanceStack.axis = .horizontal
        appearanceStack.alignment = .center
        appearanceStack.distribution = .equalSpacing
        appearanceStack.spacing = 10
        // 아이콘과 레이블의 스택뷰
        let privacyLabelwithIcon = UIStackView()
        privacyLabelwithIcon.axis = .horizontal
        privacyLabelwithIcon.spacing = 5
        [privacyIcon, privacyButton].forEach{ privacyLabelwithIcon.addArrangedSubview($0)}
        // 개인정보 스택뷰에 서브뷰 추가
        [privacyLabelwithIcon, UIView()].forEach { privacyStack.addArrangedSubview($0) }
        
        // 헬프센터 스택뷰
        let helpCenterStack = UIStackView()
        appearanceStack.axis = .horizontal
        appearanceStack.alignment = .center
        appearanceStack.distribution = .equalSpacing
        appearanceStack.spacing = 10
        // 아이콘과 레이블의 스택뷰
        let helpCenterLabelwithIcon = UIStackView()
        helpCenterLabelwithIcon.axis = .horizontal
        helpCenterLabelwithIcon.spacing = 5
        [helpIcon, helpButton].forEach{ helpCenterLabelwithIcon.addArrangedSubview($0)}
        // 헬프센터 스택뷰에 서브뷰 추가
        [helpCenterLabelwithIcon, UIView()].forEach { helpCenterStack.addArrangedSubview($0) }
        
        // 구분선을 포함하여 스택뷰에 서브뷰 추가
        [appearanceStack,
         createSeparator(),
         privacyStack,
         createSeparator(),
         helpCenterStack].forEach { stackView.addArrangedSubview($0) }
        addSubview(stackView)
        
        // stackView의 제약 조건 설정
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // 구분선 생성 함수
        func createSeparator() -> UIView {
            let separator = UIView()
            separator.backgroundColor = .lightGray.withAlphaComponent(0.5)
            separator.snp.makeConstraints { make in
                make.height.equalTo(1)
            }
            return separator
        }
    }
    private func setTintColor() {
        let color = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
        }
        [appearanceIcon, privacyIcon, helpIcon]
            .forEach{ $0.tintColor = color }
        [privacyButton, helpButton]
            .forEach{ $0.setTitleColor(color, for: .normal)}
        
    }
}


@available(iOS 17.0, *)
#Preview("HomeViewController") {
    SettingViewController()
}


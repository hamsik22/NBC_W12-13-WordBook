//
//  SettingView.swift
//  SwiftRun
//
//  Created by 황석현 on 1/13/25.
//

import UIKit
import SnapKit

class SettingView: UIView {
    private let appearanceLabel: UILabel = {
        let label = UILabel()
        label.text = "라이트/다크 모드"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.snp.makeConstraints { make in make.height.equalTo(50)}
        return label
    }()
    
    private let appearanceToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        return toggle
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("개인정보 관리정책", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.snp.makeConstraints { make in make.height.equalTo(50)}
        return button
    }()
    
    private let helpButton: UIButton = {
        let button = UIButton()
        button.setTitle("도움이 필요하신가요?", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
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
    func setup() {
        // appearanceStack 설정
        let appearanceStack = UIStackView()
        appearanceStack.axis = .horizontal
        appearanceStack.alignment = .center
        appearanceStack.distribution = .equalSpacing
        appearanceStack.spacing = 10
        [appearanceLabel, appearanceToggle].forEach { appearanceStack.addArrangedSubview($0) }
        // appearanceStack 설정
        let privacyStack = UIStackView()
        appearanceStack.axis = .horizontal
        appearanceStack.alignment = .center
        appearanceStack.distribution = .equalSpacing
        appearanceStack.spacing = 10
        [privacyButton, UIView()].forEach { privacyStack.addArrangedSubview($0) }
        
        // helpCenterStack 설정
        let helpCenterStack = UIStackView()
        appearanceStack.axis = .horizontal
        appearanceStack.alignment = .center
        appearanceStack.distribution = .equalSpacing
        appearanceStack.spacing = 10
        [helpButton, UIView()].forEach { helpCenterStack.addArrangedSubview($0) }
        
        // 메인 스택뷰에 추가
        [appearanceStack,
         createSeparator(),
         privacyStack,
         createSeparator(),
         helpCenterStack].forEach { stackView.addArrangedSubview($0) }
        addSubview(stackView)
        
        // stackView의 제약 조건 설정
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20) // 상단에 붙이기
            make.leading.trailing.equalToSuperview().inset(20)           // 좌우 여백 설정
        }
        // 구분선 생성 함수
        func createSeparator() -> UIView {
            let separator = UIView()
            separator.backgroundColor = .lightGray.withAlphaComponent(0.5)
            separator.snp.makeConstraints { make in
                make.height.equalTo(1) // 구분선 높이
            }
            return separator
        }
    }
}


@available(iOS 17.0, *)
#Preview("HomeViewController") {
    SettingViewController()
}


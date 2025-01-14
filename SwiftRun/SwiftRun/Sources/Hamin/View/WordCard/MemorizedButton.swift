//
//  MemorizedButton.swift
//  SwiftRun
//
//  Created by 김하민 on 1/8/25.
//

import UIKit
import SnapKit

final class MemorizedButton: UIButton {
    
    private var buttonWidthConstraint: Constraint?
    
    // MARK: - Initializer
    convenience init() {
        self.init(frame: .zero)
        self.titleLabel?.font = .systemFont(ofSize: 14, weight: .thin)
        self.layer.cornerRadius = 10
        
        self.snp.makeConstraints { make in
            make.height.equalTo(20)
            buttonWidthConstraint = make.width.equalTo(88).constraint
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 이 함수를 View와 ViewModel를 Bind할 때 사용해서 버튼의 색과 글자, 그리고 너비를 바꿔주면 됩니다.
    func updateButton(_ didMemorize: Bool) {
        backgroundColor = didMemorize ? .srBlue400 : .sr400Gray
        setTitle(didMemorize ? "✅" : "❌", for: .normal)
        
        buttonWidthConstraint?.update(offset: didMemorize ? 76 : 88)
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
    }
}

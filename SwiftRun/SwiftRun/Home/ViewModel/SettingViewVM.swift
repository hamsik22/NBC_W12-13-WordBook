//
//  SettingViewVM.swift
//  SwiftRun
//
//  Created by 황석현 on 1/13/25.
//

import UIKit
import RxSwift
import RxCocoa

class SettingViewVM {
    // 다크 모드 활성화 여부를 관리하는 Relay
    let isDarkModeEnabled: BehaviorRelay<Bool>
    
    // 다크/라이트 모드 토글 액션 Relay
    let toggleMode = PublishRelay<Bool>()
    
    private let disposeBag = DisposeBag()
    
    init() {
        // UserDefaults에서 저장된 다크 모드 상태 읽기
        let savedValue = UserDefaults.standard.integer(forKey: UserDefaultsKeys.appTheme.rawValue)
        let isDarkMode = savedValue == UIUserInterfaceStyle.dark.rawValue
        
        // Relay 초기화
        isDarkModeEnabled = BehaviorRelay<Bool>(value: isDarkMode)
        
        // 다크/라이트 모드 변경 처리
        bindToggleMode()
    }
    
    private func bindToggleMode() {
        toggleMode
            .subscribe(onNext: { [weak self] isDarkMode in
                guard let self = self else { return }
                
                // 현재 상태 업데이트
                self.isDarkModeEnabled.accept(isDarkMode)
                
                // UserDefaults에 저장
                let styleValue = isDarkMode ? UIUserInterfaceStyle.dark.rawValue : UIUserInterfaceStyle.light.rawValue
                UserDefaults.standard.set(styleValue, forKey: UserDefaultsKeys.appTheme.rawValue)
                
                // 변경 로그 출력
                print("🌗 [Theme Changed]: \(isDarkMode ? "Dark Mode" : "Light Mode")")
            })
            .disposed(by: disposeBag)
    }
}

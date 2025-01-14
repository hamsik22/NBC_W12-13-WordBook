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
    let isDarkModeEnabled: BehaviorRelay<Bool>
    
    let toggleMode = PublishRelay<Bool>()
    private let disposeBag = DisposeBag()
    
    init() {
        let savedValue = UserDefaults.standard.integer(forKey: UserDefaultsKeys.appTheme.rawValue)
        let isDarkMode = (savedValue == UIUserInterfaceStyle.dark.rawValue)
        
        isDarkModeEnabled = BehaviorRelay<Bool>(value: isDarkMode)
        
        toggleMode
            .subscribe(onNext: { [weak self] isDarkMode in
                self?.isDarkModeEnabled.accept(isDarkMode)
                let style = isDarkMode ? UIUserInterfaceStyle.dark.rawValue : UIUserInterfaceStyle.light.rawValue
                UserDefaults.standard.set(style, forKey: UserDefaultsKeys.appTheme.rawValue)
                print(UserDefaults.standard.integer(forKey: UserDefaultsKeys.appTheme.rawValue))
            })
            .disposed(by: disposeBag)
    }
}

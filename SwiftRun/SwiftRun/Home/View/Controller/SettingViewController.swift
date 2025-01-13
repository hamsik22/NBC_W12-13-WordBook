//
//  SettingViewController.swift
//  SwiftRun
//
//  Created by 황석현 on 1/13/25.
//

import UIKit
import RxSwift
import RxCocoa

class SettingViewController: UIViewController {
    
    private let settingView = SettingView()
    private let viewModel = SettingViewVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(settingView)
        view.backgroundColor = .systemBackground
        settingView.translatesAutoresizingMaskIntoConstraints = false
        self.title = "설정"
        NSLayoutConstraint.activate([
            settingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingView.topAnchor.constraint(equalTo: view.topAnchor),
            settingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.isDarkModeEnabled
            .bind(to: settingView.themeToggle.rx.isOn)
            .disposed(by: disposeBag)
        
        settingView.themeToggle.rx.isOn
            .bind(to: viewModel.toggleMode)
            .disposed(by: disposeBag)
        
        viewModel.isDarkModeEnabled
            .subscribe(onNext: { [weak self] isDarkMode in
                    guard let self = self else { return }
                    let style: UIUserInterfaceStyle = isDarkMode ? .dark : .light
                    UIView.animate(withDuration: 0.5) {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            for window in windowScene.windows {
                                window.overrideUserInterfaceStyle = style
                            }
                        }
                        self.view.backgroundColor = isDarkMode ? .black : .white
                    }
                })
                .disposed(by: disposeBag)
    }
}

@available(iOS 17.0, *)
#Preview("HomeViewController") {
    SettingViewController()
}

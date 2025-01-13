//
//  SettingViewController.swift
//  SwiftRun
//
//  Created by 황석현 on 1/13/25.
//

import UIKit

class SettingViewController: UIViewController {
    
    private let settingView = SettingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(settingView)
        settingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingView.topAnchor.constraint(equalTo: view.topAnchor),
            settingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

@available(iOS 17.0, *)
#Preview("HomeViewController") {
    SettingViewController()
}

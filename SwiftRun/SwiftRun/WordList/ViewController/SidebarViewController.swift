//
//  SidebarViewController.swift
//  SwiftRun
//
//  Created by 김석준 on 1/9/25.
//

import UIKit

class SidebarViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        let label = UILabel()
        label.text = "사이드바 메뉴"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        view.addSubview(label)

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

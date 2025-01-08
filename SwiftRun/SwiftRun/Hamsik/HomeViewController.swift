//
//  HomeViewController.swift
//  SwiftRun
//
//  Created by 황석현 on 1/8/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    let homeView: HomeView = {
        let view = HomeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        print("HomeViewController loaded")
        view.addSubview(homeView)
        NSLayoutConstraint.activate([
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeView.topAnchor.constraint(equalTo: view.topAnchor),
            homeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

@available(iOS 17.0, *)
#Preview("HomeViewController") {
    HomeViewController()
}

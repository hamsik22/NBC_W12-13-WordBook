//
//  HomeViewController.swift
//  SwiftRun
//
//  Created by 황석현 on 1/8/25.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    let homeView: HomeView = {
        let view = HomeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let viewModel = HomeViewVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        print("HomeViewController loaded")
        setup()
        bindCollectionView()
    }
}

// MARK: - Setup
extension HomeViewController {
    private func setup() {
        view.addSubview(homeView)
        NSLayoutConstraint.activate([
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeView.topAnchor.constraint(equalTo: view.topAnchor),
            homeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func bindCollectionView() {
        viewModel.mockItems
            .bind(to: homeView.wordBookCollectionView.rx.items(cellIdentifier: WordBookCollectionCell.identifier, cellType: WordBookCollectionCell.self)) { index, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
        
        homeView.wordBookCollectionView.rx.itemSelected
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
    }
}

@available(iOS 17.0, *)
#Preview("HomeViewController") {
    HomeViewController()
}

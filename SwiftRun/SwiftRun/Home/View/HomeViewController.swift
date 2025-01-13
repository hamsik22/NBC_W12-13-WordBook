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
            .withLatestFrom(viewModel.mockItems) { indexPath, items in
                items[indexPath.row]
            }
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        
        viewModel.itemSelected
            .subscribe(onNext: { [weak self] selectedItem in
                guard let self = self else { return }
                self.navigateToDetailScreen(with: selectedItem)
            })
            .disposed(by: disposeBag)
    }
    private func navigateToDetailScreen(with item: String) {
        let wordListViewController = WordListViewController() // WordListViewController로 변경
        self.navigationController?.pushViewController(wordListViewController, animated: true)
    }

}

@available(iOS 17.0, *)
#Preview("HomeViewController") {
    HomeViewController()
}

// 화면 이동 테스트를 위한 임시 클래스
class MockViewController: UIViewController {
    private let item: String
    
    init(item: String) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        let label = UILabel()
        label.text = "Selected Item: \(item)"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

//
//  HomeViewController.swift
//  SwiftRun
//
//  Created by 황석현 on 1/8/25.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    let homeView = HomeView()
    private let viewModel = HomeViewVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        print("HomeViewController loaded")
        setup()
    }
}

// MARK: - Setup
extension HomeViewController {
    // 레이아웃 설정
    private func setup() {
        view.addSubview(homeView)
        homeView.translatesAutoresizingMaskIntoConstraints = false
        viewModel.fetchAllCategories()
        NSLayoutConstraint.activate([
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeView.topAnchor.constraint(equalTo: view.topAnchor),
            homeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        setBind()
        
    }
    
    // 데이터 바인딩
    private func bindCollectionView() {
        // Cell 구성
        viewModel.categoriesRelay
            .bind(to: homeView.wordBookCollectionView.rx.items(cellIdentifier: WordBookCollectionCell.identifier, cellType: WordBookCollectionCell.self)) { index, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
        
        // 터치한 Cell 바인딩
        homeView.wordBookCollectionView.rx.itemSelected
            .withLatestFrom(viewModel.categoriesRelay) { indexPath, items in
                items[indexPath.row]
            }
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        
        // Cell 터치 시 화면 이동
        viewModel.itemSelected
            .subscribe(onNext: { [weak self] selectedItem in
                guard let self = self else { return }
                self.navigateToDetailScreen(with: selectedItem)
            })
            .disposed(by: disposeBag)
    }
    private func bindSettingButton() {
        homeView.settingsButton.rx.tap
                .bind(to: viewModel.navigateToSettingScreen)
                .disposed(by: disposeBag)
        
        homeView.settingsButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigateToSettingScreen()
            })
            .disposed(by: disposeBag)
    }
    private func setBind() {
        bindSettingButton()
        bindCollectionView()
    }
    private func setProfile() {
        let name = UserDefaults.standard.string(forKey: UserDefaultsKeys.userName.rawValue) ?? "학생 1"
        let count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.memorizedCount.rawValue)
        homeView.profile.configure(name: name, count: count)
    }
    
    // 화면 이동
    private func navigateToDetailScreen(with item: Category) {

        // 선택된 카테고리 ID로 URL을 생성
        let categoryId = item.id
        let urlString = "https://iosvocabulary-default-rtdb.firebaseio.com/items/category\(categoryId).json"
        print("Selected category URL: \(urlString)")  // URL 출력
            
        // WordListViewController로 화면 이동
        let wordListViewModel = WordListViewModel(categoryId: categoryId, urlString: urlString) // ViewModel을 생성하고 URL을 전달
        let wordListViewController = WordListViewController(viewModel: wordListViewModel) // ViewModel을 넘겨줌
        self.navigationController?.pushViewController(wordListViewController, animated: true)
    }
    

    private func navigateToSettingScreen() {
        let settingViewController = SettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
    
}

@available(iOS 17.0, *)
#Preview("HomeViewController") {
    HomeViewController()
}

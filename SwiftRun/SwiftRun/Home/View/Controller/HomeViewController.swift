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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("HomeViewController will appear")
        setProfile()
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
        setProfile()
        bindEditButton()
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
    private func bindEditButton() {
        homeView.profile.editProfileButton.rx.tap
            .subscribe(onNext: {
                let alertController = UIAlertController(
                        title: "이름 변경",
                        message: "새 이름을 입력하세요",
                        preferredStyle: .alert
                    )
                    
                    alertController.addTextField { textField in
                        textField.placeholder = "새 이름"
                    }
                    
                    let saveAction = UIAlertAction(title: "저장", style: .default) { [weak self] _ in
                        guard let self = self,
                              let newName = alertController.textFields?.first?.text, !newName.isEmpty else { return }
                        homeView.profile.nameLabel.text = newName
                        UserDefaults.standard.set(newName, forKey: UserDefaultsKeys.userName.rawValue)
                    }
                    
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                    
                    alertController.addAction(saveAction)
                    alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    private func setBind() {
        bindSettingButton()
        bindCollectionView()
    }
    private func setProfile() {
        let name = UserDefaults.standard.string(forKey: UserDefaultsKeys.userName.rawValue) ?? "학생 1"
        let count = UserDefaults.standard.array(forKey: "1")?.count ?? 0
        homeView.profile.configure(name: name, count: count)
    }
    
    // 화면 이동
    private func navigateToDetailScreen(with item: Category) {

        // 선택된 카테고리 ID로 URL을 생성
        let categoryId = item.id
        let urlString = "https://iosvocabulary-default-rtdb.firebaseio.com/items/category\(categoryId).json"
        print("Selected category URL: \(urlString)")  // URL 출력
            
        // WordListViewController로 화면 이동
        let wordCardStackViewModel = WordCardStackViewModel(categoryID: categoryId, urlString: urlString) // ViewModel을 생성하고 URL을 전달
        let wordListViewController = WordListViewController(viewModel: wordCardStackViewModel) // ViewModel을 넘겨줌
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

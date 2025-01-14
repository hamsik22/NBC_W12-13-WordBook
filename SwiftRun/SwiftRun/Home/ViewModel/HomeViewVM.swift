//
//  HomeViewVM.swift
//  SwiftRun
//
//  Created by 황석현 on 1/9/25.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewVM {

    // Public Relays
    let categoriesRelay = BehaviorRelay<[Category]>(value: [])
    let itemSelected = PublishRelay<Category>()
    let navigateToSettingScreen = PublishSubject<Void>()
    let errorRelay = PublishRelay<String>() // 에러 메시지 전달용

    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()

    init() {
        // 아이템 선택 이벤트 핸들링
        itemSelected
            .subscribe(onNext: { selectedItem in
                print("Selected Item: \(selectedItem.name)")
            })
            .disposed(by: disposeBag)
    }

    // 카테고리 불러오기
    func fetchAllCategories() {
        guard let url = URL(string: Url.allCategory) else {
            errorRelay.accept("Invalid URL: Unable to fetch categories.")
            return
        }

        networkManager.fetch(url: url)
            .subscribe(
                onSuccess: { [weak self] (categories: [String: Category]) in
                    guard !categories.isEmpty else {
                        self?.errorRelay.accept("No categories available.")
                        return
                    }
                    let sortedCategories = categories.sorted { $0.key < $1.key }
                    let categoryList = sortedCategories.map { $0.value }
                    self?.categoriesRelay.accept(categoryList)
                    print("✅ Fetched categories successfully: \(categoryList.count) items.")
                },
                onFailure: { [weak self] error in
                    self?.errorRelay.accept("Error fetching categories: \(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }
}

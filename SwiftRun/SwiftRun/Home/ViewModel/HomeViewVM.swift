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

    // 카테고리 데이터 관리
    let categoriesRelay = BehaviorRelay<[Category]>(value: [])
    let itemSelected = PublishRelay<Category>()
    let errorRelay = PublishRelay<String>() // 에러 메시지 전달용 Relay 추가

    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()

    init() {
        // 선택된 카테고리 출력
        itemSelected
            .subscribe(onNext: { selectedItem in
                print("Selected Category: \(selectedItem.name)")
            })
            .disposed(by: disposeBag)
    }

    // 모든 카테고리 불러오기
    func fetchAllCategories() {
        guard let url = URL(string: Url.allCategory) else {
            errorRelay.accept("Invalid URL: Unable to fetch categories.")
            return
        }

        networkManager.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (categories: [String: Category]) in
                // 데이터를 키로 정렬 후 리스트 변환
                let sortedCategories = categories.sorted { $0.key < $1.key }
                let categoryList = sortedCategories.map { $0.value }
                self?.categoriesRelay.accept(categoryList)
                print("Fetched \(categoryList.count) categories successfully.")
            }, onFailure: { [weak self] error in
                self?.errorRelay.accept("Failed to fetch categories: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    // 특정 카테고리의 항목 불러오기
    func fetchCategoryItems(categoryId: String, completion: @escaping ([Word]) -> Void) {
        guard let url = URL(string: Url.getCategory(category: CategoryKeys(rawValue: categoryId) ?? .builtInFunctions)) else {
            errorRelay.accept("Invalid URL for category \(categoryId).")
            return
        }

        networkManager.fetch(url: url)
            .subscribe(onSuccess: { (words: [String: Word]) in
                let wordList = words.map { $0.value }
                completion(wordList)
                print("Fetched \(wordList.count) words for category \(categoryId).")
            }, onFailure: { [weak self] error in
                self?.errorRelay.accept("Failed to fetch words for category \(categoryId): \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

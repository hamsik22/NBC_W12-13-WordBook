//
//  VocabularyViewModel.swift
//  SwiftRun
//
//  Created by 반성준 on 1/9/25.
//

import Foundation
import RxSwift
import RxCocoa

class VocabularyViewModel {
    // Outputs
    let vocabularies: BehaviorRelay<[Vocabulary]> = BehaviorRelay(value: [])
    let filteredVocabularies: BehaviorRelay<[Vocabulary]> = BehaviorRelay(value: [])
    let errorMessage: PublishRelay<String> = PublishRelay()
    
    // Inputs
    let searchQuery: BehaviorRelay<String> = BehaviorRelay(value: "")
    let showMemorizedOnly: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    private let disposeBag = DisposeBag()

    init() {
        // Combine vocabularies, searchQuery, and showMemorizedOnly to update filteredVocabularies
        Observable.combineLatest(vocabularies, searchQuery, showMemorizedOnly)
            .map { vocabularies, query, showMemorizedOnly in
                var result = vocabularies

                // 검색어 필터링
                if !query.isEmpty {
                    result = result.filter {
                        $0.name.contains(query) || $0.definition.contains(query)
                    }
                }

                // 암기 필터링
                if showMemorizedOnly {
                    result = result.filter { $0.didMemorize }
                }

                return result
            }
            .bind(to: filteredVocabularies)
            .disposed(by: disposeBag)
    }

    // Fetch vocabulary data
    func fetchVocabulary() {
        let url = URL(string: "https://iosvocabulary-default-rtdb.firebaseio.com/items/category1.json")!
        NetworkManager.shared.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (data: [String: Vocabulary]) in
                let vocabList = data.map { $0.value }
                self?.vocabularies.accept(vocabList)
            }, onFailure: { [weak self] error in
                self?.errorMessage.accept("데이터를 가져오는 데 실패했습니다: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    // Toggle memorize state
    func toggleMemorizeState(at index: Int) {
        var currentVocabularies = vocabularies.value
        guard index < currentVocabularies.count else { return }
        currentVocabularies[index].didMemorize.toggle()
        vocabularies.accept(currentVocabularies)
    }

    // Helper methods
    func numberOfFilteredVocabularies() -> Int {
        return filteredVocabularies.value.count
    }

    func filteredVocabulary(at index: Int) -> Vocabulary? {
        guard index < filteredVocabularies.value.count else { return nil }
        return filteredVocabularies.value[index]
    }
}

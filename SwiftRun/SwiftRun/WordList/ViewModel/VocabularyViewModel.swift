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
    let errorMessage: PublishRelay<String> = PublishRelay()

    private let disposeBag = DisposeBag()

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
    func numberOfVocabularies() -> Int {
        return vocabularies.value.count
    }

    func vocabulary(at index: Int) -> Vocabulary? {
        guard index < vocabularies.value.count else { return nil }
        return vocabularies.value[index]
    }
}

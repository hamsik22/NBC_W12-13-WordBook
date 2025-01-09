import Foundation
import RxSwift
import RxRelay

class WordListViewModel {
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    
    // BehaviorRelay로 단어 데이터 관리
    private let vocabularyRelay = BehaviorRelay<[Vocabulary]>(value: [])
    
    var vocabularies: Observable<[Vocabulary]> {
        return vocabularyRelay.asObservable()
    }

    // Vocabulary 데이터 가져오기
    func fetchVocabulary() {
        guard let url = URL(string: "https://iosvocabulary-default-rtdb.firebaseio.com/items/category1.json") else { return }
        
        networkManager.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: [String: Vocabulary]) in
                // 딕셔너리의 값을 배열로 변환
                let vocabularyList = Array(response.values)
                self?.vocabularyRelay.accept(vocabularyList)
            }, onFailure: { error in
                print("Error fetching vocabulary: \(error)")
            })
            .disposed(by: disposeBag)
    }

    func toggleMemorizeState(at index: Int) {
        var updatedList = vocabularyRelay.value
        guard index < updatedList.count else { return }
        updatedList[index].didMemorize.toggle()
        vocabularyRelay.accept(updatedList)
    }

    func vocabulary(at index: Int) -> Vocabulary? {
        let currentList = vocabularyRelay.value
        guard index < currentList.count else { return nil }
        return currentList[index]
    }

    func numberOfVocabularies() -> Int {
        return vocabularyRelay.value.count
    }
}

import Foundation
import RxSwift
import RxRelay

class WordListViewModel {
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    var categoryId: String
    var urlString: String

    private let vocabularyRelay = BehaviorRelay<[Vocabulary]>(value: [])

    var vocabularies: Observable<[Vocabulary]> {
        return vocabularyRelay.asObservable()
    }

    init(categoryId: String, urlString: String) {
        self.categoryId = categoryId
        self.urlString = urlString
    }

    func fetchVocabulary() {
        guard let url = URL(string: urlString) else { return }
        networkManager.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: [String: Vocabulary]) in
                let vocabularyList = Array(response.values)
                self?.vocabularyRelay.accept(vocabularyList)
            }, onFailure: { error in
                print("Error fetching vocabulary: \(error)")
            })
            .disposed(by: disposeBag)
    }

    // 'toggleMemorizeState(at:)' 메서드 추가
    func toggleMemorizeState(at index: Int) {
        // 현재 단어 리스트 가져오기
        var currentVocabularies = vocabularyRelay.value
        
        // 인덱스가 유효한지 확인
        guard index >= 0 && index < currentVocabularies.count else { return }
        
        // 해당 단어의 memorize 상태를 변경
        currentVocabularies[index].didMemorize.toggle()
        
        // 변경된 리스트를 BehaviorRelay에 전달
        vocabularyRelay.accept(currentVocabularies)
    }
}

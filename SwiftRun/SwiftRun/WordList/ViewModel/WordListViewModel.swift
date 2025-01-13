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

    // 카테고리 데이터를 가져오는 메서드
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

    // 'toggleMemorizeState(at:)' 메서드
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
    
    // 카테고리별 데이터 갱신 메서드
    func fetchItems(forCategory categoryId: String) {
        // 카테고리별 데이터를 가져오는 URL을 설정
        let categoryUrlString = "https://iosvocabulary-default-rtdb.firebaseio.com/items/category\(categoryId).json"
        
        // URL을 콘솔에 출력
        print("Requesting URL: \(categoryUrlString)")
        
        guard let url = URL(string: categoryUrlString) else { return }
        
        networkManager.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: [String: Vocabulary]) in
                let vocabularyList = Array(response.values)
                self?.vocabularyRelay.accept(vocabularyList)
            }, onFailure: { error in
                print("Error fetching vocabulary for category \(categoryId): \(error)")
                // 응답을 디버깅하기 위해 추가 로그 출력
                if let errorResponse = error as? NSError {
                    print("Error code: \(errorResponse.code)")
                    if let urlResponse = errorResponse.userInfo[NSURLErrorFailingURLErrorKey] {
                        print("Failed URL: \(urlResponse)")
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

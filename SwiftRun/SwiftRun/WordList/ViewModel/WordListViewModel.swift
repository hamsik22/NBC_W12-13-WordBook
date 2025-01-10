import Foundation
import RxSwift
import RxRelay

class WordListViewModel {
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    
    // 원본 데이터
    private let vocabularyRelay = BehaviorRelay<[Vocabulary]>(value: [])
    
    // 검색어와 필터 상태
    let searchQuery = BehaviorRelay<String>(value: "")
    let showMemorizedOnly = BehaviorRelay<Bool>(value: false)
    
    // 필터링된 데이터 캐싱
    private let filteredVocabularyRelay = BehaviorRelay<[Vocabulary]>(value: [])
    
    // 네트워크 오류 메시지 전달
    let errorMessage = PublishRelay<String>()
    
    // 필터링된 데이터
    var filteredVocabularies: Observable<[Vocabulary]> {
        return filteredVocabularyRelay.asObservable()
    }

    init() {
        // 검색어, 필터 상태가 변경될 때마다 필터링된 데이터를 업데이트
        Observable.combineLatest(vocabularyRelay, searchQuery, showMemorizedOnly)
            .map { vocabularies, query, showMemorizedOnly in
                vocabularies.filter { vocab in
                    let matchesQuery = vocab.name.lowercased().contains(query.lowercased()) ||
                                       vocab.definition.lowercased().contains(query.lowercased())
                    let matchesFilter = !showMemorizedOnly || vocab.didMemorize
                    return matchesQuery && matchesFilter
                }
            }
            .do(onNext: { filtered in
                print("Filtered vocabularies updated: \(filtered.count) items")
            })
            .bind(to: filteredVocabularyRelay)
            .disposed(by: disposeBag)
    }

    // Vocabulary 데이터 가져오기
    func fetchVocabulary() {
        guard let url = URL(string: "https://iosvocabulary-default-rtdb.firebaseio.com/items/category1.json") else {
            errorMessage.accept("잘못된 URL입니다.")
            return
        }
        
        networkManager.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: [String: Vocabulary]) in
                let vocabularyList = Array(response.values)
                self?.vocabularyRelay.accept(vocabularyList)
                print("Vocabulary data fetched successfully: \(vocabularyList.count) items")
            }, onFailure: { [weak self] error in
                print("Error fetching vocabulary: \(error.localizedDescription)")
                self?.errorMessage.accept("데이터를 가져오는 데 실패했습니다: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    // Memorize 상태 토글
    func toggleMemorizeState(at index: Int) {
        var updatedList = vocabularyRelay.value
        guard index < updatedList.count else { return }
        updatedList[index].didMemorize.toggle()
        vocabularyRelay.accept(updatedList)
        print("Toggled memorize state for item at index \(index)")
    }

    // 필터 및 검색 초기화
    func resetFilters() {
        searchQuery.accept("")
        showMemorizedOnly.accept(false)
        print("Filters reset: searchQuery and showMemorizedOnly reset to defaults")
    }

    // 데이터 정렬 기능 추가 (예: 이름 순 정렬)
    func sortVocabularies(by option: SortOption) {
        let sortedList: [Vocabulary]
        switch option {
        case .nameAscending:
            sortedList = vocabularyRelay.value.sorted { $0.name.lowercased() < $1.name.lowercased() }
        case .nameDescending:
            sortedList = vocabularyRelay.value.sorted { $0.name.lowercased() > $1.name.lowercased() }
        case .memorizedFirst:
            sortedList = vocabularyRelay.value.sorted { $0.didMemorize && !$1.didMemorize }
        }
        vocabularyRelay.accept(sortedList)
        print("Vocabulary sorted by \(option)")
    }

    // Helper Methods
    func filteredVocabulary(at index: Int) -> Vocabulary? {
        let filteredList = filteredVocabularyRelay.value
        guard index < filteredList.count else { return nil }
        return filteredList[index]
    }

    func numberOfFilteredVocabularies() -> Int {
        return filteredVocabularyRelay.value.count
    }
}

// 정렬 옵션 정의
enum SortOption {
    case nameAscending
    case nameDescending
    case memorizedFirst
}

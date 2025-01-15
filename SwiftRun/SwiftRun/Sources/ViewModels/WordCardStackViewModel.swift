//
//  WordCardStackViewModel.swift
//  SwiftRun
//
//  Created by 김하민 on 1/13/25.
//

import Foundation
import RxSwift
import RxRelay

protocol WordCardStackVMDelegate: AnyObject {
    func popViewController()
}

final class WordCardStackViewModel {
    
    weak var delegate: WordCardStackVMDelegate?
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    var categoryID: String
    var urlString: String
    
    private var cardsToShow: [Word] = [] {
        didSet {
            vocabularyRelay.accept(cardsToShow)
        }
    }
    var memorizedCards: Set<Int> = [] {
        didSet {
            saveMemorizedCards()
        }
    }

    
    private var index = 0
    var cardsLeft: Int {
        return cardsToShow.count
    }
    
    private let vocabularyRelay = BehaviorRelay<[Word]>(value: [])
    
    var vocabularies: Observable<[Word]> {
        return vocabularyRelay.asObservable()
    }
    
    private let wordPlaceholder = Word()
    
    lazy var currentCard = BehaviorRelay(value: cardsToShow.popLast() ?? wordPlaceholder)
    lazy var didMemorizeCurrentCard = BehaviorRelay(value: Bool())
    
    lazy var isLastCard = BehaviorRelay(value: Bool())
    
    // MARK: - Initializer
    
    init(categoryID: String, urlString: String) {
        self.categoryID = categoryID
        self.urlString = urlString
        
        fetchWords()
        loadMemorizedCards()
    }
    
    // MARK: - Functions for binding
    
    func setDelegate(to target: WordCardStackVMDelegate) {
        self.delegate = target
    }
    
    func start() {
        guard let card = cardsToShow.first else { return }
        currentCard.accept(card)
    }
    
    func nextCard() {
        guard 0..<cardsLeft - 1 ~= index else {
            delegate?.popViewController()
            return
        }
        index += 1
        let nextCard = cardsToShow[index]

        currentCard.accept(nextCard)
        updateStatus(for: nextCard)
        print(memorizedCards)
        print(nextCard)
        
        if index == cardsToShow.count - 1 {
            isLastCard.accept(true)
        }
    }
    
    func previousCard() {
        guard 1..<cardsLeft ~= index else { return }
        index -= 1
        let previousCard = cardsToShow[index]
        
        currentCard.accept(previousCard)
        updateStatus(for: previousCard)
        print(memorizedCards)
        print(previousCard)
        
        isLastCard.accept(false)
    }
    
    func memorizedButtonTapped() {
        print("memorizedButtonTapped")
        
        let currentBool: Bool = didMemorizeCurrentCard.value
        
        didMemorizeCurrentCard.accept(!currentBool)
        
        if didMemorizeCurrentCard.value && !memorizedCards.contains(currentCard.value.id) {
            memorizedCards.insert(currentCard.value.id)
        } else {
            memorizedCards = memorizedCards.filter { $0 != currentCard.value.id }
        }
    }
    
    func toggleMemorization(for wordID: Int) {
        if memorizedCards.contains(wordID) {
            memorizedCards.remove(wordID)
        } else {
            memorizedCards.insert(wordID)
        }
        saveMemorizedCards()
    }
    
    // MARK: - Other functions
    
    func fetchWords() {
        guard let url = URL(string: "https://iosvocabulary-default-rtdb.firebaseio.com/items/category\(self.categoryID).json") else { return }
        
        networkManager.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: [String: Word]) in
                // 딕셔너리의 값을 배열로 변환
                let words = Array(response.values)
                self?.cardsToShow = words
            }, onFailure: { error in
                print("Error fetching vocabulary: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func fetchItems(forCategory categoryId: String) {
        // 카테고리별 데이터를 가져오는 URL을 설정
        let categoryUrlString = "https://iosvocabulary-default-rtdb.firebaseio.com/items/category\(categoryId).json"
        
        // URL을 콘솔에 출력
        print("Requesting URL: \(categoryUrlString)")
        
        guard let url = URL(string: categoryUrlString) else { return }
        
        networkManager.fetch(url: url)
            .subscribe(onSuccess: { [weak self] (response: [String: Word]) in
                let vocabularyList = Array(response.values)
                self?.vocabularyRelay.accept(vocabularyList)
                self?.cardsToShow = vocabularyList
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
    
    private func updateStatus(for word: Word) {
        let status = memorizedCards.contains { $0 == word.id }
        didMemorizeCurrentCard.accept(status)
    }
    
}

// MARK: - UserDefaults
extension WordCardStackViewModel {
    private func loadMemorizedCards() {
        guard let memorizedCards = UserDefaults.standard.array(forKey: categoryID) as? [Int]
        else { return }
        
        self.memorizedCards = Set(memorizedCards)
    }
    
    private func saveMemorizedCards() {
        let duplicatesRemoved = Array(memorizedCards)
        UserDefaults.standard.set(duplicatesRemoved, forKey: categoryID)
    }
}

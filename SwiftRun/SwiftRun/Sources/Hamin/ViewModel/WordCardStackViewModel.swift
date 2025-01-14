//
//  WordCardStackViewModel.swift
//  SwiftRun
//
//  Created by 김하민 on 1/13/25.
//

import Foundation
import RxSwift
import RxRelay

final class WordCardStackViewModel {
    
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    
    // MARK: - Properties
    private let categoryID: String = "1"
    
    private var cardsToShow: [Word] = []
    private var memorizedCards: Set<Int> = []
    
    private var index = 0
    var cardsLeft: Int {
        return cardsToShow.count
    }
    
    private let wordPlaceholder = Word()
    
    lazy var currentCard = BehaviorRelay(value: cardsToShow.popLast() ?? wordPlaceholder)
    lazy var didMemorizeCurrentCard = BehaviorRelay(value: Bool())
    
    // MARK: - Initializer
    
    init() {
        fetchWords()
        loadMemorizedCards()
    }
    
    // MARK: - Functions for binding
    
    func start() {
        guard let card = cardsToShow.popLast() else { return }
        currentCard.accept(card)
    }
    
    func nextCard() {
        guard 0..<cardsLeft - 1 ~= index else { return }
        index += 1
        let nextCard = cardsToShow[index]

        currentCard.accept(nextCard)
        updateStatus(for: nextCard)
        print(memorizedCards)
        print(nextCard)
    }
    
    func previousCard() {
        guard 1..<cardsLeft ~= index else { return }
        index -= 1
        let previousCard = cardsToShow[index]
        
        currentCard.accept(previousCard)
        updateStatus(for: previousCard)
        print(memorizedCards)
        print(previousCard)
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
    
    // MARK: - Private functions
    
    private func fetchWords() {
        guard let url = URL(string: "https://iosvocabulary-default-rtdb.firebaseio.com/items/category1.json") else { return }
        
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

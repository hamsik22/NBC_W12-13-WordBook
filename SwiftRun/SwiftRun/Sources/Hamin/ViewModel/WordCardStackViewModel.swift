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
    
    private var cardsShown: [Word] = []
    private var cardsToShow: [Word] = []
    private var memorizedCards: [Int] = []
    
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
    
    func nextCard() {
        print("Next Card")
    
        memorizedCards.append(currentCard.value.id)
        currentCard.accept(wordPlaceholder)
    }
    
    func memorizedButtonTapped() {
        print("memorizedButtonTapped")
        
        let currentBool: Bool = didMemorizeCurrentCard.value
        
        didMemorizeCurrentCard.accept(!currentBool)
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
    


}

// MARK: - UserDefaults
extension WordCardStackViewModel {
    private func loadMemorizedCards() {
        guard let memorizedCards = UserDefaults.standard.array(forKey: categoryID) as? [Int]
        else { return }
        
        self.memorizedCards = memorizedCards
    }
    
    private func saveMemorizedCards() {
        UserDefaults.standard.set(memorizedCards, forKey: categoryID)
    }
}

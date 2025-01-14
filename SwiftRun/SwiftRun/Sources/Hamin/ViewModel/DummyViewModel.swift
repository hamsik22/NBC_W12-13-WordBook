//
//  DummyViewModel.swift
//  SwiftRun
//
//  Created by 김하민 on 1/8/25.
//

import RxSwift
import RxRelay

final class DummyViewModel {
    
    private let disposeBag = DisposeBag()
    let model = DummyModel()
    
    var currentCardSubject = PublishSubject<Word>()
    var didMemorize = BehaviorRelay(value: Bool())
    
    init() {
        currentCardSubject.subscribe(
            onNext:
                { card in
                    print("card: \(card)")
                }
            ,onError:
                { error in
                    print("error: \(error)")
                }
        ).disposed(by: disposeBag)
        
        didMemorize.subscribe(
            onNext:
                { bool in
                    print("toggled to: \(bool)")
                }
        ).disposed(by: disposeBag)
    }
    
    func getNextCard() {
        do {
            let result = try model.nextCard()
            currentCardSubject.onNext(result.word)
            didMemorize.accept(result.didMemorize)
        } catch {
            currentCardSubject.onError(error)
        }
    }
    
    func nextButtonTapped() {
        print("tapped")
        getNextCard()
    }
    
    func memorizedButtonTapped() {
        print("memorizedButtonTapped")
        
        let currentBool: Bool = didMemorize.value
        
        didMemorize.accept(!currentBool)
    }
}

final class DummyModel {
    
    lazy var cardStack: [WordCard] = []
    
    func nextCard() throws -> WordCard {
        let nextCard = cardStack.popLast()
        
        guard let nextCard = nextCard else { throw CardError.lastCardOnStack }
        
        return nextCard
    }
    
    enum CardError: Error {
        case lastCardOnStack
    }
    
}

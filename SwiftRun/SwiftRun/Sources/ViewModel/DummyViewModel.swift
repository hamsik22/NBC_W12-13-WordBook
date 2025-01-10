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
    
    lazy var cardStack = [wordCard1, wordCard2, wordCard3]
    
    func nextCard() throws -> WordCard {
        let nextCard = cardStack.popLast()
        
        guard let nextCard = nextCard else { throw CardError.lastCardOnStack }
        
        return nextCard
    }
    
    enum CardError: Error {
        case lastCardOnStack
    }
    
    
    let wordCard1: WordCard = WordCard(word: Word(id: 1,
                                                 name: "KPI",
                                                 subname: "Key Performance Indicator",
                                                 definition: "핵심 성과 지표",
                                                 details: "핵심 성과 지표로, 조직의 목표 달성을 측정하기 위한 구체적이고 측정 가능한 지표",
                                                 tag: "마케팅 용어"
                                                ),
                                      didMemorize: false)
    let wordCard2: WordCard = WordCard(word: Word(id: 2,
                                                 name: "더미데이터",
                                                 subname: "Dummy Data",
                                                 definition: "그냥 더미데이터입니다",
                                                 details: "임시로 넣어놓은 더미데이터",
                                                 tag: "임시"
                                                ),
                                      didMemorize: false)
    let wordCard3: WordCard = WordCard(word: Word(id: 3,
                                                 name: "터미네이터",
                                                 subname: "Terminator T-800",
                                                 definition: "I'll be back",
                                                 details: "That Terminator is out there! It can't be bargained with. It can't be reasoned with. It doesn't feel pity, or remorse, or fear. And it absolutely will not stop, ever! Until you are dead!",
                                                 tag: "터미네이터"
                                                ),
                                      didMemorize: false)
}

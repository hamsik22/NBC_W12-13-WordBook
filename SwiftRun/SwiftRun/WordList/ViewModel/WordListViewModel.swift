//
//  WordListViewModel.swift
//  SwiftRun
//
//  Created by 김석준 on 1/8/25.
//

import Foundation

class WordListViewModel {
    // 단어 데이터
    private(set) var vocabularyList: [Vocabulary] = [
        Vocabulary(id: 1, name: "print", subname: nil, definition: "콘솔에 출력", details: ["출력 함수"], didMemorize: true, tag: "수학 함수" ),
        Vocabulary(id: 2, name: "uppercased", subname: nil, definition: "문자열 전체를 대문자로 전환", details: ["문자열 함수"],didMemorize: false, tag: "수학 함수" ),
        Vocabulary(id: 3, name: "lowercased", subname: nil, definition: "문자열을 소문자로 변환", details: ["문자열 함수"], didMemorize: false, tag: "수학 함수" ),
        Vocabulary(id: 4, name: "lowercased", subname: nil, definition: "문자열을 소문자로 변환", details: ["문자열 함수"], didMemorize: false, tag: "수학 함수" ),
        Vocabulary(id: 5, name: "lowercased", subname: nil, definition: "문자열을 소문자로 변환", details: ["문자열 함수"], didMemorize: false, tag: "수학 함수" ),
        Vocabulary(id: 6, name: "lowercased", subname: nil, definition: "문자열을 소문자로 변환", details: ["문자열 함수"], didMemorize: false, tag: "수학 함수" ),
        Vocabulary(id: 7, name: "lowercased", subname: nil, definition: "문자열을 소문자로 변환", details: ["문자열 함수"], didMemorize: false, tag: "수학 함수" ),
        Vocabulary(id: 8, name: "lowercased", subname: nil, definition: "문자열을 소문자로 변환", details: ["문자열 함수"], didMemorize: false, tag: "수학 함수" ),
        Vocabulary(id: 9, name: "lowercased", subname: nil, definition: "문자열을 소문자로 변환", details: ["문자열 함수"], didMemorize: false, tag: "수학 함수" )
        // 데이터 추가 가능
    ]

    // Memorize 상태를 토글하는 함수
    func toggleMemorizeState(at index: Int) {
        guard index < vocabularyList.count else { return }
        vocabularyList[index].didMemorize.toggle()
    }

    // 특정 단어를 가져오는 함수
    func vocabulary(at index: Int) -> Vocabulary? {
        guard index < vocabularyList.count else { return nil }
        return vocabularyList[index]
    }

    // 단어 개수를 반환하는 함수
    func numberOfVocabularies() -> Int {
        return vocabularyList.count
    }
}

//
//  Word.swift
//  SwiftRun
//
//  Created by 김하민 on 1/8/25.
//

struct Word {
    let id: Int
    let name: String
    let subname: String?
    let definition: String
    let details: String?
    let tag: String
}

struct WordCard {
    let word: Word
    var didMemorize: Bool = false
}

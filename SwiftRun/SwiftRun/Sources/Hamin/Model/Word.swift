//
//  Word.swift
//  SwiftRun
//
//  Created by 김하민 on 1/8/25.
//

import Foundation

struct Word: Decodable {
    let id: Int
    let name: String
    let subname: String?
    let definition: String
    let details: String?
    let tag: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case subname = "subName" // JSON의 키와 맞추기 위해 커스텀 키 정의
        case definition
        case details
        case tag
    }
}

struct WordCard {
    let word: Word
    var didMemorize: Bool = false
}

//
//  Word.swift
//  SwiftRun
//
//  Created by 김하민 on 1/8/25.
//

struct Word: Codable {
    let id: Int
    let name: String
    let subName: String?
    let definition: String
    let details: [String]
    let tag: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, subName = "sub_name", definition, details, tag
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        definition = try container.decode(String.self, forKey: .definition)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        subName = try container.decodeIfPresent(String.self, forKey: .subName)
        tag = try container.decode(String.self, forKey: .tag)
        
        // `details` 필드가 배열 또는 문자열일 경우 처리
        if let detailsArray = try? container.decode([String].self, forKey: .details) {
            details = detailsArray
        } else if let detailsString = try? container.decode(String.self, forKey: .details) {
            details = [detailsString]
        } else {
            details = []
        }
    }
    
    init() {
        id = -1
        name = ""
        subName = nil
        definition = ""
        details = []
        tag = ""
    }
}

struct WordCard {
    let word: Word
    var didMemorize: Bool = false
}

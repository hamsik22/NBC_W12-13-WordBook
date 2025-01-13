//
//  Model.swift
//  SwiftRun
//
//  Created by 김석준 on 1/8/25.
//

import Foundation

struct Vocabulary: Decodable {
    let definition: String
    let details: [String?]
    let id: Int
    let name: String
    let subName: String?
    let tag: String
    var didMemorize: Bool

    enum CodingKeys: String, CodingKey {
        case definition, details, id, name, subName = "sub_name", tag, didMemorize
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        definition = try container.decode(String.self, forKey: .definition)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        subName = try container.decodeIfPresent(String.self, forKey: .subName)
        tag = try container.decode(String.self, forKey: .tag)
        
        // `details` 필드가 배열 또는 문자열일 경우 처리
        if let detailsArray = try? container.decode([String?].self, forKey: .details) {
            details = detailsArray
        } else if let detailsString = try? container.decode(String.self, forKey: .details) {
            details = [detailsString]
        } else {
            details = []
        }
        
        // `didMemorize`가 없을 경우 기본값 false
        didMemorize = try container.decodeIfPresent(Bool.self, forKey: .didMemorize) ?? false
    }
}

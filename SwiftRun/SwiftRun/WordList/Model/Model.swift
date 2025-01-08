//
//  Model.swift
//  SwiftRun
//
//  Created by 김석준 on 1/8/25.
//

import Foundation

struct Vocabulary{
    let id: Int
    let name: String
    let subname: String?
    let definition: String
    let details: [String]
    var didMemorize: Bool
    let tag: String
}

//
//  MemorizedButton.swift
//  SwiftRun
//
//  Created by 김하민 on 1/8/25.
//

import UIKit
import RxSwift
import RxCocoa

final class MemorizedButton: UIButton {
    
    func updateButton(_ didMemorize: Bool) {
        backgroundColor = didMemorize ? .srBlue400 : .sr400Gray
        setTitle(didMemorize ? "외웠어요" : "못외웠어요", for: .normal)
    }
}

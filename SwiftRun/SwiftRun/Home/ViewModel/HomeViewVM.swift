//
//  HomeViewVM.swift
//  SwiftRun
//
//  Created by 황석현 on 1/9/25.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewVM {
    // 데이터를 관리하기 위해 BehaviorRelay 사용
        let mockItems = BehaviorRelay<[String]>(value: ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"])
        let itemSelected = PublishRelay<String>()
        private let disposeBag = DisposeBag()
        
        init() {
            itemSelected
                .subscribe(onNext: { selectedItem in
                    print("Selected Item: \(selectedItem)")
                })
                .disposed(by: disposeBag)
        }
}

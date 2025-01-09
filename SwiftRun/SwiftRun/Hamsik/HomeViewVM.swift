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
    
    let mockItems: Observable<[String]> = Observable.just(["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"])
    
    let itemSelected = PublishRelay<IndexPath>()
    
    private let disposeBag = DisposeBag()
    
    init() {
            itemSelected
                .subscribe(onNext: { indexPath in
                    print("Selected Item at \(indexPath.row)")
                    // 여기에 비즈니스 로직 추가
                })
                .disposed(by: disposeBag)
        }
}

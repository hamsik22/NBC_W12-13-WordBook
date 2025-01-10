//
//  WordCardStackViewController.swift
//  SwiftRun
//
//  Created by 김하민 on 1/8/25.
//

import UIKit
import SnapKit

final class WordCardStackViewController: UIViewController {
    
    let viewModel = DummyViewModel()
    let wordCardView = WordCardView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController loaded")
        wordCardView.bind(to: viewModel)
        view.addSubview(wordCardView)
        setConstraints()
    }
    
    
    private func setConstraints() {
        wordCardView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
}

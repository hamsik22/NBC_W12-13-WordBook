//
//  WordCardStackViewController.swift
//  SwiftRun
//
//  Created by 김하민 on 1/8/25.
//

import UIKit
import SnapKit

final class WordCardStackViewController: UIViewController {

    let viewModel: WordCardStackViewModel
    let wordCardView = WordCardView()
    

    // MARK: - Initializer
    
    init(with viewModel: WordCardStackViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.setDelegate(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController loaded")
        wordCardView.bind(to: viewModel)
        view.addSubview(wordCardView)
        setConstraints()
        viewModel.start()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(viewModel.cardsLeft)
    }
    
    
    private func setConstraints() {
        wordCardView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

extension WordCardStackViewController: WordCardStackVMDelegate {
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}

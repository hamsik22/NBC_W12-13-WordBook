//
//  WordCardStackViewController.swift
//  SwiftRun
//
//  Created by 김하민 on 1/8/25.
//

import UIKit
import SnapKit

final class WordCardStackViewController: UIViewController {
    
    let viewModel = WordCardStackViewModel()
    let wordCardView = WordCardView()
    let anotherWordCardView = WordCardView()
    
    private var originalPosition = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController loaded")
        wordCardView.bind(to: viewModel)
        view.addSubview(wordCardView)
        view.addSubview(anotherWordCardView)
        anotherWordCardView.bind(to: viewModel)
        setConstraints()
        wordCardView.layer.zPosition = 0
        anotherWordCardView.layer.zPosition = 1
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        wordCardView.addGestureRecognizer(panGesture)
        anotherWordCardView.addGestureRecognizer(panGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        originalPosition = wordCardView.center
        print(viewModel.cardsLeft)
    }
    
    
    private func setConstraints() {
        wordCardView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        anotherWordCardView.snp.makeConstraints { make in
            make.edges.equalTo(wordCardView.snp.edges)
        }
    }
}

// MARK: - Pan Gesture handler

extension WordCardStackViewController {
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let viewToDrag = gesture.view else { return }
        
        let translation = gesture.translation(in: view)
        print("original position: " + self.originalPosition.debugDescription)

        switch gesture.state {
        case .began: print("Begined dragging")
        case .changed:
            viewToDrag.center = CGPoint(x: viewToDrag.center.x + translation.x,
                                        y: viewToDrag.center.y + translation.y)
            
            gesture.setTranslation(.zero, in: view)
            print("Position changed")
        case .ended:
            print("\(self.originalPosition)")
            UIView.animate(withDuration: 0.1) {
                viewToDrag.center = self.originalPosition
            }
            print("Ended dragging")
        case .cancelled: print("Cancelled dragging")
        case .possible: print("Ready to drag")
        case .failed: print("Failed")
        @unknown default: print("Unknown state")
        }
    }
}

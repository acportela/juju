//
//  TrainLevelViewController.swift
//  juju
//
//  Created by Antonio Portela on 17/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol TrainLevelViewControllerDelegate: AnyObject {
    
    func trainLevelViewController(_ controller: TrainLevelViewController,
                                  didChooseLevel level: TrainingLevel)
}

final class TrainLevelViewController: UIViewController {
    
    public static let title = "Nível do treino"
    
    private let trainLevelView = TrainingLevelView()
    
    private var currentLevel: TrainingLevel
    
    weak var delegate: TrainLevelViewControllerDelegate?
    
    init(currentLevel: TrainingLevel) {
        
        self.currentLevel = currentLevel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        self.view = self.trainLevelView
        self.trainLevelView.delegate = self
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.trainLevelView.configure(with: .selectLevel(self.currentLevel))
        self.trainLevelView.closeWasTapped = { self.dismiss(animated: true, completion: nil) }
    }
}

extension TrainLevelViewController: TrainingLevelViewDelegate {
    
    func trainingLevelView(_ view: TrainingLevelView, didSelectLevel level: TrainingLevel) {
        
        self.currentLevel = level
        self.delegate?.trainLevelViewController(self, didChooseLevel: level)
    }
}

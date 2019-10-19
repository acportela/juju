//
//  TrainingViewController.swift
//  juju
//
//  Created by Antonio Portela on 07/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol TrainingViewControllerDelegate: AnyObject {
    
    func trainingViewControllerDidTapLevelSettings(_ controller: TrainingViewController,
                                                   withCurrentLevel level: TrainingLevel)
}

final class TrainingViewController: UIViewController, Loadable {
    
    public static let title = "Treino"
    
    private let trainingView = TrainingView(defaultSerie: .fallback)
    private var dataSource: TrainingDataSource
    let loadingController = LoadingViewController(animatable: JujuLoader())
    weak var delegate: TrainingViewControllerDelegate?
    
    init(mode: TrainingMode,
         localDefaults: LocalStorageProtocol,
         diaryService: TrainingDiaryServiceProtocol,
         trainingService: TrainingServiceProtocol,
         user: ClientUser) {
        
        self.dataSource = TrainingDataSource(mode: mode,
                                             localStorage: localDefaults,
                                             diaryService: diaryService,
                                             trainingService: trainingService,
                                             user: user)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        self.view = trainingView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.trainingView.delegate = self
        self.dataSource.delegate = self
        self.addBackgroundObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.configureNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.initialDiarySetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.stopTrain()
        self.dataSource.unregisterListeners()
        super.viewWillDisappear(animated)
    }
    
    private func configureNavigation() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = TrainingViewController.title
        
        let barButton = UIBarButtonItem(image: Resources.Images.levelsIcon,
                                        style: .plain,
                                        target: self,
                                        action: #selector(self.didTapLevelSettings))
        self.navigationItem.rightBarButtonItem = barButton
        
        let item = UIBarButtonItem(title: .empty, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
}

extension TrainingViewController {
    
    private func initialDiarySetup() {

        guard let serie = self.dataSource.currentSerie else {
            
            self.startLoading()
            self.dataSource.fetchTrainingModels()
            return
        }
        
        self.initScreenWithSerie(serie)
    }
    
    func updatePreferredLevel(_ newLevel: TrainingLevel) {
        
        self.dataSource.updatePreferredLevel(newLevel)
        self.trainingView.configure(with: .stop)
        self.initScreenWithSerie(self.dataSource.currentSerie ?? .fallback)
    }
    
    private func startTrain() {
        
        self.trainingView.configure(with: .start)
    }
    
    private func stopTrain() {
        
        self.trainingView.configure(with: .stop)
    }
    
    private func initScreenWithSerie(_ serie: Series) {
        
        self.trainingView.configure(with: .initial(serie))
    }
    
    private func showDefaultTrainingAlert() {
        
        let message = "Ocorreu um erro ao buscar seu treino. Usaremos o treino padrão"
        Snackbar.showError(message: message, in: self.view)
    }
}

// MARK: TrainingView Delegate
extension TrainingViewController: TrainingViewDelegate {

    func trainingViewWantsToStartTrain(_ trainingView: TrainingView) {
        
        self.startTrain()
    }
    
    func trainingViewWantsToStopTrain(_ trainingView: TrainingView) {
        
        self.stopTrain()
    }
    
    func trainingViewFinishedSerie(_ trainingView: TrainingView, serie: Series) {
        
        self.dataSource.updateCurrentDiaryWithSerie(serie)
    }
}

// MARK: Datasource Delegate
extension TrainingViewController: TrainingDataSourceDelegate {
    
    func trainingDataSourceFetchedDiary(_ dataSource: TrainingDataSource, error: RepositoryError?) {
        
        self.stopLoading()
        
        if let error = error {
            
            if error == .noResults {
                
                // New day
                let models = self.dataSource.availableTrainings
                ?? TrainingConstants.defaultTrainingModels
                self.dataSource.setNewDiary(DiaryProgress(date: Date(), models: models))
                
            } else {
                
                self.initScreenWithSerie(.fallback)
                self.showDefaultTrainingAlert()
                return
            }
        }
        
        self.initScreenWithSerie(self.dataSource.currentSerie ?? .fallback)
    }
    
    func trainingDataSourceTrainingModelWasUpdated(_ dataSource: TrainingDataSource, error: Bool) {
        
        if self.dataSource.currentSerie == nil {
            
            self.dataSource.fetchTodayDiary()
        }
    }
}

extension TrainingViewController {
    
    @objc
    private func didTapLevelSettings() {
        
        self.delegate?.trainingViewControllerDidTapLevelSettings(self,
                                                                 withCurrentLevel: self.dataSource.level)
    }
    
    private func addBackgroundObserver() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.applicationWillEnterBackground),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    @objc
    private func applicationWillEnterBackground() {
        
        self.stopTrain()
    }
}

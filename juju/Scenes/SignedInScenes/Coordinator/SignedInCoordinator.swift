//
//  SignedInCoordinator.swift
//  juju
//
//  Created by Antonio Portela on 04/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol SignedInCoordinatorDelegate: AnyObject {
    
    func signedInCoordinatorDidLogout(_ coordinator: SignedInCoordinator)
}

class SignedInCoordinator: NSObject, Coordinator {
    
    private var rootNavigation: UINavigationController
    private let diaryService: TrainingDiaryServiceProtocol
    private let userService: UserServiceProtocol
    private let localStorage: LocalStorageProtocol
    private let user: ClientUser
    
    weak var delegate: SignedInCoordinatorDelegate?
    
    private lazy var trainingCoordinator: Coordinator = {
        
        let coordinator = TrainingCoordinator(rootNavigation: self.trainingNavigation,
                                              diaryService: self.diaryService,
                                              localDefaults: self.localStorage,
                                              user: self.user)
        return coordinator
    }()
    
    private lazy var tabBarController: JujuTabBarController  = {
        
        let controllers = self.setupTabControllers()
        return JujuTabBarController(viewControllers: controllers, initialIndex: 1)
    }()
    
    private let trainingNavigation: UINavigationController = {
        
        let controller = UINavigationController()
        controller.tabBarItem = UITabBarItem(title: .empty,
                                             image: Resources.Images.tabExercise,
                                             selectedImage: nil)
        return controller
    }()

    init(rootController: UINavigationController,
         userService: UserServiceProtocol,
         diaryService: TrainingDiaryServiceProtocol,
         localStorage: LocalStorageProtocol,
         user: ClientUser) {
        
        self.user = user
        self.rootNavigation = rootController
        self.userService = userService
        self.diaryService = diaryService
        self.localStorage = localStorage
    }
    
    func start() {
        
        self.setupNavigationBar()
        self.trainingCoordinator.start()
        self.rootNavigation.pushViewController(self.tabBarController, animated: false)
    }
    
    private func setupNavigationBar() {
        
        self.rootNavigation.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTabControllers() -> [UIViewController] {
        
        let video = UIViewController()
        video.tabBarItem = UITabBarItem(title: "Vídeos",
                                        image: Resources.Images.tabVideo,
                                        selectedImage: nil)
        
        //TODO: Move to a Profile Coordinator later on
        let profile = ProfileViewController(loggerUser: self.user,
                                            userService: self.userService)
        profile.delegate = self
        profile.tabBarItem = UITabBarItem(title: "Perfil",
                                          image: Resources.Images.tabProfile,
                                          selectedImage: nil)
        
        let calendar = UIViewController()
        calendar.tabBarItem = UITabBarItem(title: "Calendário",
                                           image: Resources.Images.tabCalendar,
                                           selectedImage: nil)
        
        return [calendar, trainingNavigation, video, profile]
    }
}

extension SignedInCoordinator: ProfileViewControllerDelegate {
    
    func profileViewControllerDidLogout(_ controller: ProfileViewController, success: Bool) {
        
        if self.rootNavigation.topViewController == self.tabBarController {
            self.rootNavigation.popViewController(animated: true)
        }
        self.delegate?.signedInCoordinatorDidLogout(self)
    }
}

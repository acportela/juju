//
//  SignInViewController.swift
//  juju
//
//  Created by Antonio Rodrigues on 21/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol SignInViewControllerDelegate: AnyObject {
    
    func signInViewController(_ viewController: SignInViewController, didSignInWithUser user: ClientUser)
    func signInViewControllerDidTapBack(_ viewController: SignInViewController)
}

final class SignInViewController: SignedOutThemeViewController {
    
    private let signInView = SignInView()
    private let userService: UserService
    weak var delegate: SignInViewControllerDelegate?
    
    init(userService: UserService) {
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        self.view = signInView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupCallbacks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KeyboardListener.shared.register(signInView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KeyboardListener.shared.remove(signInView)
    }
    
    func setupCallbacks() {
        
        signInView.onBackTap = { [weak self] in
            
            guard let sSelf = self else { return }
            sSelf.delegate?.signInViewControllerDidTapBack(sSelf)
        }
        
        signInView.onDoneAction = { [weak self] in
            
            guard let sSelf = self else { return }
            
            guard sSelf.signInView.fieldsAreValid, let credentials = sSelf.credentials() else {
                
                sSelf.enableErrorState("Verifique os campos e tente novamente")
                return
            }
            
            sSelf.proceedWithSignIn(email: credentials.email, pass: credentials.pass)
        }
    }

    private func credentials() -> (email: String, pass: String)? {
        
        guard let email = signInView.emailInput.currentValue,
              let pass = signInView.passwordInput.currentValue else {
                return nil
        }
        
        return (email: email, pass: pass)
    }
    
    func proceedWithSignIn(email: String, pass: String) {
        
        self.userService.userWantsToSignIn(email: email, password: pass) { result in
            switch result {
            case .success(let user):
                self.delegate?.signInViewController(self, didSignInWithUser: user)
            case .error:
                //TODO Add treatment
                break
            }
        }
    }
    
    //TODO Remove once error interface is refined
    private func enableErrorState(_ message: String) {
        
        let alert = UIAlertController(title: "Atenção", message: message, primaryActionTitle: "OK")
        self.present(alert, animated: true)
    }
}
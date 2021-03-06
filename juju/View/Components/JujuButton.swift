//
//  JujuButton.swift
//  juju
//
//  Created by Antonio Rodrigues on 01/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class JujuButton: UIView {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.titleEdgeInsets = UIEdgeInsets(top: Styling.Spacing.twelve,
                                              left: Styling.Spacing.sixteen,
                                              bottom: Styling.Spacing.twelve,
                                              right: Styling.Spacing.sixteen)
        button.layer.masksToBounds = true
        button.backgroundColor = theme.backgroundColor
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    var onTapAction: (() -> Void)?
    
    private let theme: BackgroundContext
    
    init(title: String, backgroundContext: BackgroundContext, frame: CGRect = .zero) {
        
        self.theme = backgroundContext
        super.init(frame: frame)
        self.button.setTitle(title.capitalized,
                             withColor: backgroundContext.textColor,
                             andFont: Resources.Fonts.Gilroy.extraBold(ofSize: Styling.FontSize.twenty))
        setupViewConfiguration()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Initialize with view code")
    }
}

extension JujuButton: ViewCoding {
    
    func addSubViews() {
        
        addSubview(button)
    }
    
    func setupConstraints() {
        
        button.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
    }
    
    func configureViews() { }
    
}

extension JujuButton {
    
    @objc
    private func buttonAction() {
        
        self.onTapAction?()
    }
}

extension JujuButton {
    
    enum BackgroundContext {
        
        case dark
        case light
        
        var textColor: UIColor {
            
            switch self {
                
            case .dark:
                
                return Styling.Colors.rosyPink
                
            case .light:
                
                return Styling.Colors.white
            }
        }
        
        var backgroundColor: UIColor {
            
            switch self {
                
            case .dark:
                
                return Styling.Colors.white
                
            case .light:
                
                return Styling.Colors.rosyPink
            }
        }
    }
}

extension JujuButton: ViewConfiguration {
    
    enum Configuration {
        
        case toggleState(enabled: Bool)
    }
    
    func configure(with state: Configuration) {
        
        switch state {
            
        case .toggleState(let enabled):
            
            button.isEnabled = enabled
            let background = theme.backgroundColor
            button.backgroundColor = enabled ? background : background.withAlphaComponent(Constants.buttonAlpha)
        }
    }
}

extension JujuButton {
    
    struct Constants {
        
        static let buttonCornerRadius: CGFloat = 25
        static let buttonAlpha: CGFloat = 0.3
    }
}

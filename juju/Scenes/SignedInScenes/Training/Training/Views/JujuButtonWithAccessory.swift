//
//  TrainingFooterButton.swift
//  juju
//
//  Created by Antonio Portela on 07/09/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit
import SnapKit

final class JujuButtonWithAccessory: UIView {
    
    // MARK: Views
    private let title: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = Styling.Colors.white
        label.font = Resources.Fonts.Gilroy.extraBold(ofSize: Styling.FontSize.twenty)
        return label
    }()
    
    private let subtitle: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = Styling.Colors.white
        label.font = Resources.Fonts.Rubik.regular(ofSize: Styling.FontSize.fourteen)
        return label
    }()
    
    private let accessoryView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: Properties
    public var wasTappedCallback: (() -> Void)?
    
    // MARK: Lifecycle
    
    override init(frame: CGRect = .zero) {
        
        super.init(frame: frame)
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("Initialize with view code")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = Constants.backgroundAlpha
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = Constants.defaultAlpha
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.alpha = Constants.defaultAlpha
    }
}

extension JujuButtonWithAccessory: ViewCoding {
    
    func addSubViews() {
        
        self.addSubview(title)
        self.addSubview(subtitle)
        self.addSubview(accessoryView)
    }
    
    func setupConstraints() {
        
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Styling.Spacing.twentyeight)
            make.top.equalToSuperview().offset(Styling.Spacing.twelve)
            make.bottom.equalToSuperview().offset(-Styling.Spacing.fourteen)
        }
        
        accessoryView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Styling.Spacing.fourteen)
            make.centerY.equalToSuperview()
        }
        
        subtitle.snp.makeConstraints { make in
            make.right.equalTo(accessoryView.snp.left).offset(-Styling.Spacing.fourteen)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureViews() {
        
        self.backgroundColor = Styling.Colors.rosyPink
        self.layer.cornerRadius = Constants.buttonCornerRadius
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped))
        self.addGestureRecognizer(tapGesture)
    }
}

extension JujuButtonWithAccessory {
    
    @objc
    private func viewWasTapped() {
        
        self.wasTappedCallback?()
    }
}

extension JujuButtonWithAccessory: ViewConfiguration {
    
    enum States {
        
        case initial(JujuButtonWithAccessoryConfiguration)
    }
    
    func configure(with state: JujuButtonWithAccessory.States) {
        
        switch state {
            
        case .initial(let state):
            
            self.title.text = state.title
            self.subtitle.text = state.subtitle
            self.accessoryView.image = state.accessoryImage
        }
    }
}

extension JujuButtonWithAccessory {
    
    struct Constants {
        
        static let accessoryImageSide = 24
        static let buttonCornerRadius: CGFloat = 25
        static let backgroundAlpha: CGFloat = 0.3
        static let defaultAlpha: CGFloat = 1
    }
}

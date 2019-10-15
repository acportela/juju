//
//  SnackBarView.swift
//  juju
//
//  Created by Antonio Portela on 13/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

class SnackbarView: UIView {
    
    lazy var labelInfo: UILabel = {
        
        let lbl = UILabel()
        lbl.font = Resources.Fonts.Gilroy.regular(ofSize: Styling.FontSize.fourteen)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    lazy var buttonClose: UIButton = {
        
        let btn = UIButton()
        btn.tintColor = .white
        return btn
    }()
    
    lazy var viewContainer = UIView()
    
    private var tap: UITapGestureRecognizer!
    
    init(message: String,
         backgroundColor: UIColor,
         image: UIImage,
         messageColor: UIColor = .white) {
        
        super.init(frame: .zero)
        
        self.labelInfo.text = message
        self.labelInfo.textColor = messageColor
        self.buttonClose.setImage(image, for: .normal)
        
        self.viewContainer.backgroundColor = backgroundColor
        
        self.setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.roundCorners([.topRight, .topLeft], radius: 10)
        
        self.addShadow(color: .black,
                       opacity: 0.15,
                       radius: 10.0,
                       offset: .init(width: 0, height: -2.0),
                       clipsToBounds: false,
                       masksToBounds: false)
    }
    
}

extension SnackbarView: ViewCoding {
    
    func addSubViews() {
        
        self.addSubview(viewContainer)
        self.viewContainer.addSubview(labelInfo)
        self.viewContainer.addSubview(buttonClose)
    }
    
    func setupConstraints() {
        
        self.viewContainer.snp.makeConstraints { make in
            
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        self.labelInfo.snp.makeConstraints { make in
            
            make.top.equalTo(self.viewContainer.snp.top).offset(30)
            make.left.equalTo(self.viewContainer.snp.left).offset(52)
            make.bottom.equalTo(self.viewContainer.snp.bottom).inset(30)
            make.right.equalTo(self.viewContainer.snp.right).inset(16)
            make.height.greaterThanOrEqualTo(20)
        }
        
        self.buttonClose.snp.makeConstraints { make in
            
            make.top.equalTo(self.viewContainer.snp.top).offset(28)
            make.left.equalTo(self.viewContainer.snp.left).inset(16)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        
    }
    
    func configureViews() {
        
        self.isUserInteractionEnabled = true
        self.tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        self.addGestureRecognizer(self.tap)
        
        self.viewContainer.layer.borderWidth = 0.5
        self.viewContainer.layer.borderColor = Styling.Colors.veryLightPink.cgColor
        self.backgroundColor = .clear
    }
    
}

extension SnackbarView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        
        self.clipsToBounds = false
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.viewContainer.layer.mask = mask
        
    }
    
}

extension SnackbarView {
    
    func show(in view: UIView) {
        
        self.setupInConstraints(view: view)
        
        self.layoutIfNeeded()
        view.layoutIfNeeded()
        
        let keyboardHeight = KeyboardListener.shared.keyboardHeight
        let top = view.bounds.height - self.bounds.height - keyboardHeight
        
        self.snp.updateConstraints { update in
            
            update.top.equalTo(top)
        }
        
        UIView.animate(withDuration: 0.3) {
            
            view.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            self.hide()
        }
    }
    
    @objc func hide() {
        
        guard let superview = self.superview else {
            
            return
        }
        
        self.snp.updateConstraints { update in
            
            update.top.equalTo(superview.bounds.height)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            
            superview.layoutIfNeeded()
            
        }, completion: { completed in
            
            if completed {
                
                self.removeFromSuperview()
            }
        })
        
    }
    
    func setupInConstraints(view: UIView) {
        
        view.addSubview(self)
        view.bringSubviewToFront(self)
        
        self.snp.makeConstraints { make in
            
            make.width.equalTo(view)
            make.top.equalTo(view.bounds.height - KeyboardListener.shared.keyboardHeight)
            make.top.equalTo(view.bounds.height)
        }
    }
    
}
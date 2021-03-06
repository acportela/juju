//
//  ViewCodingProtocol.swift
//  juju
//
//  Created by Antonio Rodrigues on 29/06/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import UIKit

protocol ViewCoding: UIView {
    
    func addSubViews()
    func setupConstraints()
    func configureViews()
    func setupViewConfiguration()
}

extension ViewCoding {
    
    func setupViewConfiguration() {
        addSubViews()
        setupConstraints()
        configureViews()
    }
    
    func configureViews() { }
}

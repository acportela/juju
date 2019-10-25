//
//  UrineLoss.swift
//  juju
//
//  Created by Antonio Rodrigues on 24/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

enum UrineLoss: Int, RawRepresentable, Codable {

    case none
    case low
    case moderate
    case high

    static let fallback = UrineLoss.none
}

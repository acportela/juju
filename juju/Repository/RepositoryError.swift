//
//  RepositoryError.swift
//  juju
//
//  Created by Antonio Rodrigues on 17/07/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

enum RepositoryError: Error {
    
    case unknown
    case noResults
    case unauthorized
    case resourceExausted
    case cancelled
    case malformedQuery
    case corruptedData
}

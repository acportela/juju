//
//  TrainingDiary.swift
//  juju
//
//  Created by Antonio Portela on 02/10/19.
//  Copyright © 2019 Antonio Rodrigues. All rights reserved.
//

import Foundation

struct DiaryProgress: Codable {
    
    let date: Date
    let series: [Series]
}

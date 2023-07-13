//
//  Alert.swift
//  PlanBee
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

struct Alert: Codable, Hashable {
    let id: UUID
    var date: Date
    var isOn: Bool = true
}

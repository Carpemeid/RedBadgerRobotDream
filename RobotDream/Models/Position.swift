//
//  Position.swift
//  RobotDream
//
//  Created by Dan Andoni on 01/09/2018.
//  Copyright © 2018 Dan Andoni. All rights reserved.
//

import Foundation

struct Position: CustomStringConvertible {
    let x: UInt
    let y: UInt
    let orientation: Orientation
    
    var description: String {
        return "\(x) \(y) \(orientation.rawValue)"
    }
}

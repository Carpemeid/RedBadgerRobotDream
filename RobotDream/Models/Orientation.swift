//
//  Orientation.swift
//  RobotDream
//
//  Created by Dan Andoni on 01/09/2018.
//  Copyright © 2018 Dan Andoni. All rights reserved.
//

import Foundation

enum Orientation: String {
    case north = "N"
    case west = "W"
    case south = "S"
    case east = "E"
    
    private static let allCases: [Orientation] = [.north, .west, .south, .east]
    
    var toTheLeft: Orientation {
        return offsetted(by: 1)
    }
    
    var toTheRight: Orientation {
        return offsetted(by: -1)
    }
    
    private func offsetted(by value: Int) -> Orientation {
        guard let currentIndex = Orientation.allCases.index(of: self) else {
            return .north
        }
        
        return orientation(for: currentIndex.advanced(by: value))
    }
    
    private func orientation(for index: Int) -> Orientation {
        guard index >= 0 && index < Orientation.allCases.count else {
            guard index < 0 else {
                return Orientation.allCases[0]
            }
            
            return Orientation.allCases[Orientation.allCases.count - 1]
        }
        
        return Orientation.allCases[index]
    }
}

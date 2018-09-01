//
//  PositionCalculator.swift
//  RobotDream
//
//  Created by Dan Andoni on 01/09/2018.
//  Copyright © 2018 Dan Andoni. All rights reserved.
//

import Foundation

protocol PositionCalculator {
    func nextPosition(from position: Position, move: Move) -> Position?
    func isValid(position: Position) -> Bool
}

final class PositionCalculatorImpl: PositionCalculator {
    private let board: Board
    
    init(board: Board) {
        self.board = board
    }
    
    func nextPosition(from position: Position, move: Move) -> Position? {
        let newPosition: Position
        
        switch move {
        case .forward:
            newPosition = forward(for: position)
        case .left:
            newPosition = Position(x: position.x, y: position.y, orientation: position.orientation.toTheLeft)
        case .right:
            newPosition = Position(x: position.x, y: position.y, orientation: position.orientation.toTheRight)
        }
        
        guard isValid(position: newPosition) else {
            return nil
        }
        
        return newPosition
    }
    
    private func forward(for position: Position) -> Position {
        switch position.orientation {
        case .east:
            return Position(x: position.x + 1, y: position.y, orientation: position.orientation)
        case .north:
            return Position(x: position.x, y: position.y + 1, orientation: position.orientation)
        case .south:
            return Position(x: position.x, y: position.y - 1, orientation: position.orientation)
        case .west:
            return Position(x: position.x - 1, y: position.y, orientation: position.orientation)
        }
    }
    
    func isValid(position: Position) -> Bool {
        return board.maxX >= position.x && board.maxY >= position.y
    }
}

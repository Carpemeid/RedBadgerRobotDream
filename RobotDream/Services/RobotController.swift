//
//  RobotController.swift
//  RobotDream
//
//  Created by Dan Andoni on 01/09/2018.
//  Copyright © 2018 Dan Andoni. All rights reserved.
//

import Foundation

enum RobotControllerError: Error {
    case SOS(position: Position)
}

protocol RobotController {
    func position(for startingPosition: Position, moves: [Move]) throws -> Position?
}

final class RobotControllerImpl {
    private let positionCalculator: PositionCalculator
    private var scentPositionMoves: [(Position, Move)] = []
    
    init(positionCalculator: PositionCalculator) {
        self.positionCalculator = positionCalculator
    }
}

extension RobotControllerImpl: RobotController {
    func position(for startingPosition: Position, moves: [Move]) throws -> Position? {
        guard !moves.isEmpty else {
            return startingPosition
        }
        
        let finalPosition: Position = try moves.reduce(startingPosition) { position, move in
            guard hasScent(for: move, at: position) else {
                return position
            }
            
            guard let nextPosition = positionCalculator.nextPosition(from: position, move: move) else {
                addScent(move: move, at: position)
                throw RobotControllerError.SOS(position: position)
            }
            
            return nextPosition
        }
        
        return finalPosition
    }
    
    private func hasScent(for move: Move, at position: Position) -> Bool {
        return scentPositionMoves.contains { (localPosition, localMove) in
            let samePosition = localPosition.x == position.x && localPosition.y == position.y && localPosition.orientation == position.orientation
            let sameMove = localMove == move
            
            return samePosition && sameMove
        }
    }
    
    private func addScent(move: Move, at position: Position) {
        guard hasScent(for: move, at: position) else {
            return
        }
        
        scentPositionMoves.append((position, move))
    }
}

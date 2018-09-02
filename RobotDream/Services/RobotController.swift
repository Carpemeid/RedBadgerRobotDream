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
    case invalidStartingPosition
}

protocol RobotController {
    func position(for startingPosition: Position, moves: [Move]) throws -> Position
}

final class RobotControllerImpl {
    private let positionCalculator: PositionCalculator
    private var scentPositions: [Position] = []
    
    init(positionCalculator: PositionCalculator) {
        self.positionCalculator = positionCalculator
    }
}

extension RobotControllerImpl: RobotController {
    func position(for startingPosition: Position, moves: [Move]) throws -> Position {
        guard positionCalculator.isValid(position: startingPosition) else {
            throw RobotControllerError.invalidStartingPosition
        }
        
        guard !moves.isEmpty else {
            return startingPosition
        }
        
        let finalPosition: Position = try moves.reduce(startingPosition) { position, move in
            do {
                return try positionCalculator.nextPosition(from: position, move: move)
            } catch RobotPositionError.outsideBoard(let outsideBoardPosition) {
                guard !hasScent(for: outsideBoardPosition) else {
                    return position
                }
                
                addScent(at: outsideBoardPosition)
                
                throw RobotControllerError.SOS(position: position)
            } catch {
                throw RobotControllerError.SOS(position: position)
            }
        }
        
        return finalPosition
    }
    
    private func hasScent(for position: Position) -> Bool {
        return scentPositions.contains { localPosition in
            return localPosition.x == position.x && localPosition.y == position.y
        }
    }
    
    private func addScent(at position: Position) {
        guard !hasScent(for: position) else {
            return
        }
        
        scentPositions.append(position)
    }
}

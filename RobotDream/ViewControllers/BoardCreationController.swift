//
//  BoardCreationController.swift
//  RobotDream
//
//  Created by Dan Andoni on 01/09/2018.
//  Copyright © 2018 Dan Andoni. All rights reserved.
//

import UIKit

enum BoardInputError {
    case nonNumericInput
    case zero
    case biggerThanFifty
    case emptyInput
}

enum BoardInputCheckResult {
    case success(UInt)
    case failure(BoardInputError)
    
    var value: UInt? {
        guard case .success(let value) = self else {
            return nil
        }
        
        return value
    }
    
    var error: BoardInputError? {
        guard case .failure(let error) = self else {
            return nil
        }
        
        return error
    }
}

class BoardCreationController: UIViewController {
    @IBOutlet private weak var errorLabel: UILabel!
    
    @IBOutlet private weak var xTextField: UITextField!
    @IBOutlet private weak var yTextField: UITextField!
    
    @IBOutlet private weak var createButton: UIButton!
    
    @IBAction private func didChangeTextForX(_ sender: Any) {
        refreshState()
    }
    
    @IBAction private func didChangeTextForY(_ sender: Any) {
        refreshState()
    }
    
    @IBAction private func createAction(_ sender: Any) {
        guard let xValue = numericValueResult(from: xTextField).value,
            let yValue = numericValueResult(from: yTextField).value else {
                errorLabel.isHidden = false
                errorLabel.text = "Oops, something went wrong. Please correct your input and try again"
                
                return
        }
        
        let board = Board(maxX: xValue, maxY: yValue)
        let positionCalculator = PositionCalculatorImpl(board: board)
        let robotController = RobotControllerImpl(positionCalculator: positionCalculator)
        
        let robotPlaygroundViewController = RobotPlaygroundViewController(robotController: robotController)
        
        navigationController?.pushViewController(robotPlaygroundViewController, animated: true)
    }
    
    private func refreshState() {
        errorLabel.isHidden = true
        
        let xResult = numericValueResult(from: xTextField)
        let yResult = numericValueResult(from: yTextField)
        
        guard xResult.value != nil,
              yResult.value != nil else {
                createButton.isHidden = true
                
                // try to only highlight the error of the focused field
                // more intuitive for the user
                if let xError = xResult.error,
                    xTextField.isFirstResponder {
                    showLabel(with: xError)
                    return
                }
                
                if let yError = yResult.error,
                    yTextField.isFirstResponder {
                    showLabel(with: yError)
                    return
                }
                
                guard let error = xResult.error ?? yResult.error else {
                    return
                }
                
                showLabel(with: error)
                
                return
        }
        
        createButton.isHidden = false
    }
    
    private func showLabel(with error: BoardInputError) {
        errorLabel.isHidden = false
        
        switch error {
        case .biggerThanFifty:
            errorLabel.text = "Even though you're in God mode, we still believe Mars can't be bigger than 50 by 50"
        case .nonNumericInput:
            errorLabel.text = "Seems like even on Mars the dimensions should be expressed in digits"
        case .zero:
            errorLabel.text = "We do believe in zero and infinity, but let's not try the limits of this simulation"
        case .emptyInput:
            errorLabel.isHidden = true
        }
    }
    
    private func numericValueResult(from textField: UITextField) -> BoardInputCheckResult {
        guard !(textField.text?.isEmpty ?? true) else {
            return .failure(.emptyInput)
        }
        
        guard let input = textField.text,
            let intValue = Int(input) else {
                return .failure(.nonNumericInput)
        }
        
        guard intValue > 0 else {
            return .failure(.zero)
        }
        
        guard intValue <= 50 && intValue >= 0 else {
            return .failure(.biggerThanFifty)
        }
        
        return .success(UInt(intValue))
    }
}

extension BoardCreationController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string) )
    }
}

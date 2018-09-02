//
//  RobotPlaygroundViewController.swift
//  RobotDream
//
//  Created by Dan Andoni on 01/09/2018.
//  Copyright © 2018 Dan Andoni. All rights reserved.
//

import UIKit

class RobotPlaygroundViewController: UIViewController {
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet fileprivate weak var showMeYourMovesTextField: UITextField!
    @IBOutlet fileprivate weak var yCoordinatesTextField: UITextField!
    @IBOutlet fileprivate weak var xCoordinatesTextField: UITextField!
    @IBOutlet fileprivate weak var startHeadingTextField: UITextField!
    
    private let robotController: RobotController
    
    init(robotController: RobotController) {
        self.robotController = robotController
        
        super.init(nibName: String(describing: RobotPlaygroundViewController.self), bundle: nil)
    }
    
    override private init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("this initializer is not available")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("this initializer is not available")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Robots playground"
    }
    
    @IBAction private func generateAction(_ sender: Any) {
        let focusedInput = [yCoordinatesTextField, xCoordinatesTextField, startHeadingTextField, showMeYourMovesTextField]
            .first { $0?.isFirstResponder ?? false } as? UITextField
        
        refreshState(focusedInput: focusedInput ?? showMeYourMovesTextField)
    }
    
    private func refreshState(focusedInput: UITextField) {
        resultLabel.isHidden = true
        
        guard let xCoordinatesText = xCoordinatesTextField.text,
              !xCoordinatesText.isEmpty,
              let yCoordinatesText = yCoordinatesTextField.text,
              !yCoordinatesText.isEmpty,
              let showMeYourMovesText = showMeYourMovesTextField.text,
              !showMeYourMovesText.isEmpty,
              let headingText = startHeadingTextField.text,
              !headingText.isEmpty else {
                resultLabel.isHidden = true
                return
        }
        
        // try to only highlight the error of the focused field
        // more intuitive for the user
        let xCoordinates = number(from: xCoordinatesText)
        let yCoordinates = number(from: yCoordinatesText)
        let robotMoves = moves(from: showMeYourMovesText)
        let robotHeading = heading(from: headingText)
        
        switch focusedInput {
        case xCoordinatesTextField:
            if xCoordinates == nil {
                showError(text: "Please use digits for coordinates")
                return
            }
        case yCoordinatesTextField:
            if yCoordinates == nil {
                showError(text: "Please use digits for coordinates")
                return
            }
        case showMeYourMovesTextField:
            if robotMoves == nil {
                showError(text: "Please use only L, R, F commands")
                return
            }
        case startHeadingTextField:
            if robotHeading == nil {
                showError(text: "Please use only W,E,S,N characters")
                return
            }
        default: ()
        }
        
        generateResult(xCoordinates: xCoordinates, yCoordinates: yCoordinates, heading: robotHeading, moves: robotMoves)
    }
    
    private func generateResult(xCoordinates: UInt?, yCoordinates: UInt?, heading: Orientation?, moves: [Move]?) {
        guard let xCoordinates = xCoordinates,
              let yCoordinates = yCoordinates,
              let moves = moves,
              let heading = heading else {
                showError(text: "Oops, something went wrong. Please correct your input")
                return
        }
        
        let position = Position(x: xCoordinates, y: yCoordinates, orientation: heading)
        
        do {
            let resultPosition = try robotController.position(for: position, moves: moves)
            
            showResult(text: resultPosition.description)
        } catch RobotControllerError.SOS(let position) {
            showError(text: "\(position) LOST")
        } catch RobotControllerError.invalidStartingPosition {
            showError(text: "Seems like your robot is on another planet. Please correct your starting position")
        } catch {
            showError(text: "Oops, something went wrong. Please correct your input")
        }
    }
    
    private func heading(from text: String) -> Orientation? {
        guard isValid(value: text, for: "WENS")  else {
            return nil
        }
        
        return Orientation(rawValue: text.uppercased())
    }
    
    private func moves(from text: String) -> [Move]? {
        guard isValid(value: text, for: "LRF")  else {
            return nil
        }
        
        return text.uppercased().compactMap { Move(rawValue: String($0)) }
    }
    
    fileprivate func isValid(value: String, for filter: String) -> Bool {
        let clearedValue = value.components(separatedBy: " ").joined().uppercased()
        return clearedValue.filter { !filter.uppercased().contains($0)  }.isEmpty
    }
    
    private func number(from text: String) -> UInt? {
        guard let intValue = UInt(text) else {
                return nil
        }
        
        return intValue
    }
    
    private func showResult(text: String) {
        resultLabel.isHidden = false
        resultLabel.text = text
        resultLabel.textColor = .black
    }
    
    private func showError(text: String) {
        resultLabel.isHidden = false
        resultLabel.text = text
        resultLabel.textColor = .red
    }
}

extension RobotPlaygroundViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case xCoordinatesTextField, yCoordinatesTextField:
            return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string) )
        case startHeadingTextField:
            let totalCharactersCount = (textField.text?.count ?? 0) + string.count
            
            let hasCorrectCount = totalCharactersCount < 2
            
            return isValid(value: string, for: "WENS") && hasCorrectCount
        default:
            return isValid(value: string, for: "LRF")
        }
    }
}

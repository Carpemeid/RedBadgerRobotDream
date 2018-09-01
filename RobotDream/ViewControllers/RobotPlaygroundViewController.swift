//
//  RobotPlaygroundViewController.swift
//  RobotDream
//
//  Created by Dan Andoni on 01/09/2018.
//  Copyright © 2018 Dan Andoni. All rights reserved.
//

import UIKit

class RobotPlaygroundViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var showMeYourMovesTextField: UITextField!
    @IBOutlet weak var yCoordinatesTextField: UITextField!
    @IBOutlet weak var xCoordinatesTextField: UITextField!
    
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
    
    @IBAction func didChangeXCoordinates(_ sender: UITextField) {
        refreshState()
    }
    
    @IBAction func ddiChangeYCoordinates(_ sender: UITextField) {
        refreshState()
    }
    
    @IBAction func didChangeMoves(_ sender: UITextField) {
        refreshState()
    }
    
    func refreshState() {
        guard xCoordinatesTextField.text?.isEmpty ?? false,
              yCoordinatesTextField.text?.isEmpty ?? false,
            showMeYourMovesTextField.text?.isEmpty ?? false else {
                resultLabel.isHidden = true
                return
        }
        
        
    }
}

extension RobotPlaygroundViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string) )
    }
}

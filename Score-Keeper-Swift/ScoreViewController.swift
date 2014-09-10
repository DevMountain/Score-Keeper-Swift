//
//  ScoreViewController.swift
//  Score-Keeper-Swift
//
//  Created by Joshua Howland on 8/10/14.
//  Copyright (c) 2014 DevMountain. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController, UITextFieldDelegate {
    
    let margin: CGFloat = 20.0
    let scoreViewHeight: CGFloat = 90.0
    
    var scoreLabels: Array<UILabel>?
    
    var scrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Score Keeper"
        
        scoreLabels = []
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        self.view.addSubview(scrollView!)
        
        for index in 0...3 {
            self.addScoreView(index)
        }
        
    }
    
    func addScoreView(index: NSInteger) {
        
        let nameFieldWidth: CGFloat = 90.0
        let scoreFieldWidth: CGFloat = 60.0
        let stepperButtonWidth: CGFloat = 90.0
        
        let width = self.view.frame.size.width
        
        var view = UIView(frame: CGRectMake(CGFloat(0.0), CGFloat(index) * scoreViewHeight, width, scoreViewHeight))
        
        var nameField = UITextField(frame: CGRectMake(margin, margin, nameFieldWidth, 44))
        nameField.tag = -1000
        nameField.delegate = self
        nameField.placeholder = "Name"
        view.addSubview(nameField)
        
        // We need to store the index we're adding as the tag of the text field so that we can find the corresponding button when the text changes
        
        var scoreLabel = UILabel(frame: CGRectMake(margin + nameFieldWidth, margin, scoreFieldWidth, 44))
        scoreLabel.text = "0"
        scoreLabel.textAlignment = .Center
        scoreLabels?.append(scoreLabel)
        view.addSubview(scoreLabel)
        
        
        // We need to store the index we're adding as the tag of the button so we can find the corresponding text when the user taps the button
        
        var scoreStepper = UIStepper(frame: CGRectMake(margin * 3 + nameFieldWidth + scoreFieldWidth, margin + 10, stepperButtonWidth, 44))
        scoreStepper.maximumValue = 1000
        scoreStepper.minimumValue = -1000
        scoreStepper.tag = index
        scoreStepper.addTarget(self, action:Selector("scoreStepperChanged:"), forControlEvents: .ValueChanged)
        view.addSubview(scoreStepper)
        
        var separator = UIView(frame: CGRectMake(0, scoreViewHeight - 1, self.view.frame.size.width, 1))
        separator.backgroundColor = .lightGrayColor()
        view.addSubview(separator)
        
        scrollView?.addSubview(view)
        
    }
    
    func scoreStepperChanged(sender: AnyObject) {
        var scoreStepper :UIStepper = sender as UIStepper
        let index = scoreStepper.tag
        let value = Int(scoreStepper.value)
        
        var scoreLabel :UILabel = scoreLabels![index]
        scoreLabel.text = NSString(format: "%d", value)
    }
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
}

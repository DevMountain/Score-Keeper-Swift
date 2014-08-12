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

    var scoreViews: Array<UIView>?
    var scoreFields: Array<UITextField>?
    var scoreButtons: Array<UIStepper>?
    
    var scrollView: UIScrollView?
    var addButton: UIButton?
    var removeButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Score Keeper"
        
        scoreViews = []
        scoreFields = []
        scoreButtons = []

        scrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        self.view.addSubview(scrollView!)
        
        self.addScoreView()
    
    }
    
    func addScoreView() {
    
        let nameFieldWidth: CGFloat = 90.0
        let scoreFieldWidth: CGFloat = 60.0
        let stepperButtonWidth: CGFloat = 90.0

        let index = scoreViews?.count
        let width = self.view.frame.size.width
        
        var view = UIView(frame: CGRectMake(CGFloat(0.0), CGFloat(index!) * scoreViewHeight, width, scoreViewHeight))
        
        // We set the nameField tag as -1000 so that we can ignore it when we set the score via the textfield
        
        var nameField = UITextField(frame: CGRectMake(margin, margin, nameFieldWidth, 44))
        nameField.tag = -1000
        nameField.delegate = self
        nameField.placeholder = "Name"
        view.addSubview(nameField)
        
        // We need to store the index we're adding as the tag of the text field so that we can find the corresponding button when the text changes

        var scoreField = UITextField(frame: CGRectMake(margin + nameFieldWidth, margin, scoreFieldWidth, 44))
        scoreField.tag = index!
        scoreField.delegate = self
        scoreField.text = "0"
        scoreField.placeholder = "Score"
        scoreField.textAlignment = .Center
        scoreFields?.append(scoreField)
        view.addSubview(scoreField)
        
        // Black Diamond:
        scoreField.keyboardType = .NumberPad;
        // Because we use the numberpad we need to add a done button to the textfield
        var doneItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("dismissButtonPressed:"))
        doneItem.tag = index!;
        var flexibleItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        var toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        toolbar.setItems([flexibleItem, doneItem], animated: false)
        scoreField.inputAccessoryView = toolbar;
        
        // We need to store the index we're adding as the tag of the button so we can find the corresponding text when the user taps the button

        var scoreStepper = UIStepper(frame: CGRectMake(margin * 3 + nameFieldWidth + scoreFieldWidth, margin + 10, stepperButtonWidth, 44))
        scoreStepper.maximumValue = 1000
        scoreStepper.minimumValue = -1000
        scoreStepper.tag = index!
        scoreStepper.addTarget(self, action:Selector("scoreStepperChanged:"), forControlEvents: .ValueChanged)
        scoreButtons?.append(scoreStepper)
        view.addSubview(scoreStepper)
        
        var separator = UIView(frame: CGRectMake(0, scoreViewHeight - 1, self.view.frame.size.width, 1))
        separator.backgroundColor = .lightGrayColor()
        view.addSubview(separator)
        
        scoreViews?.append(view)
        scrollView?.addSubview(view)
        
        self.updateButtonView()
        
    }
    
    func updateButtonView() {
        
        let count = scoreViews?.count
        let buttonWidth: CGFloat = 130.0
        
        if addButton == nil {
            
            addButton = UIButton.buttonWithType(.System) as? UIButton
            addButton?.setTitle("Add Player", forState:.Normal)
            addButton?.addTarget(self, action: "addScoreView", forControlEvents: .TouchUpInside)
            scrollView?.addSubview(addButton!)
        }
        
        addButton?.frame = CGRectMake(margin, CGFloat(count!) * scoreViewHeight + margin, buttonWidth, 44);
        
        if removeButton == nil {
        
            removeButton = UIButton.buttonWithType(.System) as? UIButton
            removeButton?.setTitle("Remove Player", forState:.Normal)
            removeButton?.addTarget(self, action: "removeLastScore", forControlEvents: .TouchUpInside)
            scrollView?.addSubview(removeButton!)
        }
        
        removeButton?.frame = CGRectMake(buttonWidth + 2.0 * margin, CGFloat(count!) * scoreViewHeight + margin, buttonWidth, 44);

    
        self.updateScrollViewContentSize()
    }
    
    func removeLastScore() {
    
        var view = self.scoreViews?.last
        view?.removeFromSuperview()
        
        self.scoreViews?.removeLast()
        
        self.updateButtonView()
        
    }
    
    func scoreStepperChanged(sender: AnyObject) {
        var scoreStepper :UIStepper = sender as UIStepper
        let index = scoreStepper.tag
        let value = Int(scoreStepper.value)
        
        var scoreField :UITextField = scoreFields![index]
        scoreField.text = NSString(format: "%d", value)
    }

    func updateScrollViewContentSize() {
    
        scrollView?.contentSize = CGSizeMake(self.view.frame.size.width, self.scrollViewContentHeight());

    }
    
    func scrollViewContentHeight() -> CGFloat {

        let count = scoreViews?.count
        return CGFloat(count! + 1) * scoreViewHeight
    
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
    
        var value = (textField.text as NSString).doubleValue
        var stepper: UIStepper = scoreButtons![textField.tag]
        stepper.value = value
        
        textField.resignFirstResponder()
        
        return true;
    }
    
    func dismissButtonPressed(sender: AnyObject) {
        
        var scoreField :UITextField! = scoreFields?[sender.tag]
        
        var value = (scoreField.text as NSString).doubleValue
        var stepper: UIStepper = scoreButtons![scoreField.tag]
        stepper.value = value
        
        scoreField?.resignFirstResponder()

    }

}

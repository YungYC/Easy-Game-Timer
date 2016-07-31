//
//  ViewController.swift
//  MyTimer
//
//  Created by Duncan on 2016/6/13.
//  Copyright © 2016年 Duncan. All rights reserved.
//

import UIKit
import AudioToolbox


var settingTime = 60

class ViewController: UIViewController, UITextFieldDelegate {
    
    var timeStart = settingTime * 100
    var isCounting = false
    var myTimer: NSTimer?
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var myButtom: UIButton!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var OK: UIButton!
    
    @IBAction func myButton(sender: AnyObject) {
        
        if isCounting{
            myTimer!.invalidate()
            countInit()
        }else{
            myTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(ViewController.counting), userInfo: nil, repeats: true)
            
            myButtom.setImage(UIImage(named: "stop"), forState: .Normal)
            isCounting = true
            AudioServicesPlaySystemSound(1113)

        }
    }
    
    
    func countInit(){
        timeStart = settingTime * 100
        isCounting = false
        myButtom.setImage(UIImage(named: "play"), forState: .Normal)
        
        
        if myTimer != nil{
            //KYCTimer.invalidate()
            //fourColorCircularProgress.progress = 0
        }
    }
    
    func counting(){
        timeStart -= 1
        mainLabel.text = "\(timeStart / 100)" + "." 
        label2.text = "\(timeStart % 100)"
        
        if timeStart == 0{
            AudioServicesPlaySystemSound(1304)
            myTimer!.invalidate()
        }
        
        let normalizedProgress = Double((timeStart % 100)) / 100.0
        //print(normalizedProgress)
        fourColorCircularProgress.progress = normalizedProgress
        
        if fourColorCircularProgress.progress == 0{
            AudioServicesPlaySystemSound(1113)

        }
    
    }
    
    func longPressed(sender: UILongPressGestureRecognizer){

        if myTimer != nil{
            myTimer!.invalidate()
        }
        countInit()
        label2.text = "00"
        OK.hidden = false
        
        fourColorCircularProgress.progress = 1

        timeTextField.hidden = false
        timeTextField.becomeFirstResponder()
        
    }
    
    @IBAction func OKButton(sender: AnyObject) {
        
        if timeTextField.text != "" && timeTextField.text != "0" && timeTextField.text != "00"{
            settingTime = Int(timeTextField.text!)!
            NSUserDefaults.standardUserDefaults().setObject(settingTime, forKey: "settingTime")
            
            OK.hidden = true
            timeTextField.resignFirstResponder()
            timeTextField.hidden = true
            mainLabel.text = "\(settingTime)" + "."
            countInit()
        }
    }
    
    var fourColorCircularProgress: KYCircularProgress!
    var KYCTimer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults.standardUserDefaults().objectForKey("settingTime") != nil{
            settingTime = NSUserDefaults.standardUserDefaults().objectForKey("settingTime") as! Int
            mainLabel.text = "\(settingTime)" + "."

        }

        
        KYCStart()
        countInit()

        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPressed(_:)))

        self.view.subviews[1].addGestureRecognizer(longPressRecognizer)
        //print(self.view.subviews[1])
        //print(self.view.subviews[2])
        //print(self.view.subviews[3])

    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let length = (textField.text?.utf16.count)! + string.utf16.count - range.length
        
        return length <= 2
    }
    
    
    ////轉圈特效

    
    func KYCStart(){
        configureFourColorCircularProgress()
        //KYCTimer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: #selector(ViewController.updateProgress), userInfo: nil, repeats: true)
        fourColorCircularProgress.center.x = view.center.x
        fourColorCircularProgress.center.y = mainLabel.center.y + 20
        fourColorCircularProgress.progress = 1

    }

    func configureFourColorCircularProgress() {
        
        //let fourColorCircularProgressFrame = CGRectMake(0, 0, CGRectGetWidth(mainLabel.frame) + 120, CGRectGetHeight(mainLabel.frame) + 150)
        let fourColorCircularProgressFrame = CGRectMake(0, 0, 280, 310)
        
        fourColorCircularProgress = KYCircularProgress(frame: fourColorCircularProgressFrame)
        fourColorCircularProgress.colors = [UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)]
        
        view.insertSubview(fourColorCircularProgress, atIndex: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("warning!")
    }

    var progress: UInt8 = 0
    
    func updateProgress() {
        //progress = progress &+ 1
        //let normalizedProgress = (Double(progress) / 51.0) - Double(progress / 51)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}


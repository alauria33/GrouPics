//
//  Create3ViewController.swift
//  GrouPics
//
//  Created by Andrew on 3/28/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class Create4ViewController: UIViewController {
    
    let pw = UITextField() as UITextField
    let mySwitch = UISwitch() as UISwitch
    //@IBOutlet weak var mySwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySwitch.frame = CGRectMake(0, 0, screenSize.width * 0.3, screenSize.height * 0.09)
        mySwitch.frame.origin.x = (screenSize.width - mySwitch.frame.size.width)/2
        mySwitch.frame.origin.y = (screenSize.height - mySwitch.frame.size.height)*0.5
        mySwitch.tintColor = UIColor(red: 71/255, green: 153/255, blue: 255/255, alpha: 1.0)
        mySwitch.onTintColor = UIColor(red: 46/255, green: 106/255, blue: 202/255, alpha: 1.0)
        mySwitch.on = false
        self.view.addSubview(mySwitch)
        
        pw.placeholder = " password"
        pw.frame = CGRectMake(0, 0, screenSize.width * 0.7, screenSize.height * 0.05)
        pw.frame.origin.x = (screenSize.width - pw.frame.size.width)/2
        pw.frame.origin.y = mySwitch.frame.origin.y + screenSize.height*0.085
        pw.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
        let borderColor = UIColor(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0)
        pw.layer.borderColor = borderColor.CGColor;
        pw.layer.borderWidth = 1.0;
        pw.layer.cornerRadius = 5.0;
        pw.userInteractionEnabled = false
        pw.backgroundColor = UIColor.clearColor()
        pw.autocapitalizationType = .None
        pw.autocorrectionType = .No
        pw.spellCheckingType = .No
        pw.secureTextEntry = true
        self.view.addSubview(pw)
        // Do any additional setup after loading the view.
        let tv = UITextView()
        tv.frame = CGRectMake(0, 0, screenSize.width*0.85, screenSize.height * 0.15)
        tv.frame.origin.x = (screenSize.width - tv.frame.size.width)/2.5
        tv.frame.origin.y = (screenSize.height - tv.frame.size.height)*0.36
        tv.backgroundColor = UIColor.clearColor()
        tv.text = "Allow only certain guests and individuals to join your GrouPics Event by enabling password protection."
        tv.font = UIFont(name: "Arial", size: 15)
        tv.userInteractionEnabled = false
        self.view.addSubview(tv)
        
        let circle : UIImage? = UIImage(named:"circle")
        let next   = UIButton(type: UIButtonType.System) as UIButton
        next.titleLabel!.font = UIFont(name: "ChalkboardSE-Bold", size: 21)
        next.frame = CGRectMake(0, 0, screenSize.width * 0.3, screenSize.height * 0.09)
        next.frame.origin.x = (screenSize.width - next.frame.size.width)/2
        next.frame.origin.y = (screenSize.height - next.frame.size.height)*0.82
        next.setTitle("Next", forState: UIControlState.Normal)
        let blueColor = UIColor(red: 136/255, green: 175/255, blue: 239/255, alpha: 1.0)
        next.setTitleColor(blueColor, forState: UIControlState.Normal)
        next.setBackgroundImage(circle, forState: UIControlState.Normal)
        next.addTarget(self, action: #selector(Create3ViewController.nextAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(next)
        
        mySwitch.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchChanged(sender:UISwitch!) {
        if mySwitch.on {
            pw.userInteractionEnabled = true
            pw.backgroundColor = UIColor.whiteColor()
        }
        else {
            pw.userInteractionEnabled = false
            pw.backgroundColor = UIColor.clearColor()
            pw.text = ""
        }
    }
    
    func nextAction(sender:UIButton!) {
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("createView5") as UIViewController
        createNavController.pushViewController(v, animated: true)
        
        let tempRef = ref.childByAppendingPath("/password")
        tempRef.setValue(pw.text)
        pw.userInteractionEnabled = false
        pw.backgroundColor = UIColor.clearColor()
        pw.text = ""
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
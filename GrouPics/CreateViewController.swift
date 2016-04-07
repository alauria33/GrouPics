//
//  CreateViewController.swift
//  GrouPics
//
//  Created by Andrew on 3/27/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit
import Firebase

var nameInput: String = String()
var descriptionInput: String = String()

class CreateViewController: UIViewController {

    let circle : UIImage? = UIImage(named:"circle")
    let buttonImg = UIImageView()
    @IBOutlet weak var next: UIButton!
    var name: UITextView!
    var descrip: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let next   = UIButton(type: UIButtonType.System) as UIButton
        next.titleLabel!.font = UIFont(name: "ChalkboardSE-Bold", size: 21)
        next.frame = CGRectMake(0, 0, screenSize.width * 0.3, screenSize.height * 0.09)
        next.frame.origin.x = (screenSize.width - next.frame.size.width)/2
        next.frame.origin.y = (screenSize.height - next.frame.size.height)*0.82
        next.setTitle("Next", forState: UIControlState.Normal)
        let blueColor = UIColor(red: 136/255, green: 175/255, blue: 239/255, alpha: 1.0)
        let darkBlueColor = UIColor(red: 0/255, green: 48/255, blue: 92/255, alpha: 1.0)
        let lightBlueColor = UIColor(red: 50/255, green: 70/255, blue: 147/255, alpha: 1.0)
        next.setTitleColor(lightBlueColor, forState: UIControlState.Normal)
        let arrow : UIImage? = UIImage(named:"arrow")
        //next.setBackgroundImage(arrow, forState: UIControlState.Normal)
        next.addTarget(self, action: #selector(CreateViewController.nextAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        next.addTarget(self, action: #selector(CreateViewController.clickAction(_:)), forControlEvents: UIControlEvents.TouchDown)
        next.addTarget(self, action: #selector(CreateViewController.dragAction(_:)), forControlEvents: UIControlEvents.TouchDragExit)
        buttonImg.frame = CGRectMake(0, 0, next.frame.size.width/1.3, next.frame.size.width/1.6)
        buttonImg.frame.origin.x = (screenSize.width - buttonImg.frame.size.width)/1.95
        buttonImg.frame.origin.y = (next.frame.origin.y + screenSize.height/42)
        //let grayColor = UIColor(red: 137/255, green: 140/255, blue: 145/255, alpha: 1.0)
        buttonImg.image = UIImage(named: "arrow")
        self.view.addSubview(buttonImg)
        let borderColor = UIColor(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0)
        
        name = UITextView()
        name.frame = CGRectMake(0, 0, screenSize.width * 0.7, screenSize.height * 0.05)
        name.frame.origin.x = (screenSize.width - name.frame.size.width)/2
        name.frame.origin.y = (screenSize.height - name.frame.size.height)*0.28
        name.layer.borderColor = borderColor.CGColor;
        name.layer.borderWidth = 0.8;
        name.layer.cornerRadius = 5.0;
        self.view.addSubview(name)
        
        let nameLabel = UILabel()
        nameLabel.text = "name"
        nameLabel.font = UIFont(name: "ChalkboardSE", size: 16*screenSize.width/320)
        nameLabel.frame = CGRectMake(0, 0, screenSize.width*0.2, screenSize.height * 0.15)
        nameLabel.frame.origin.x = (screenSize.width  - nameLabel.frame.size.width)/1.9
        nameLabel.frame.origin.y = name.frame.origin.y - screenSize.height/10
        self.view.addSubview(nameLabel)
        
        descrip = UITextView()
        descrip.frame = CGRectMake(0, 0, screenSize.width * 0.7, screenSize.height * 0.3)
        descrip.frame.origin.x = (screenSize.width - descrip.frame.size.width)/2
        descrip.frame.origin.y = (screenSize.height - descrip.frame.size.height)*0.55
        descrip.layer.borderColor = borderColor.CGColor;
        descrip.layer.borderWidth = 0.8;
        descrip.layer.cornerRadius = 5.0;
        self.view.addSubview(descrip)
        
        let descripLabel = UILabel()
        descripLabel.text = "description"
        descripLabel.font = UIFont(name: "ChalkboardSE", size: 16*screenSize.width/320)
        descripLabel.frame = CGRectMake(0, 0, screenSize.width*0.3, screenSize.height * 0.15)
        descripLabel.frame.origin.x = (screenSize.width - descripLabel.frame.size.width)/1.9
        descripLabel.frame.origin.y = descrip.frame.origin.y - screenSize.height/10
        self.view.addSubview(descripLabel)
        
        self.view.addSubview(next)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func nextAction(sender:UIButton!) {
        buttonImg.alpha = 1.0
//        if (name.text! == "") {
//            if (descrip.text! == "") {
//                let alert = UIAlertView()
//                alert.title = "Wait a Sec"
//                alert.message = "Please enter an Event Name & Description"
//                alert.addButtonWithTitle("Understood")
//                alert.show()
//            }
//            else {
//                let alert = UIAlertView()
//                alert.title = "Wait a Sec"
//                alert.message = "Please enter an Event Name"
//                alert.addButtonWithTitle("Understood")
//                alert.show()
//            }
//        }
//        else if (descrip.text! == "") {
//            let alert = UIAlertView()
//            alert.title = "Wait a sec"
//            alert.message = "Please enter an Event Description"
//            alert.addButtonWithTitle("Understood")
//            alert.show()
//        }
//        else {
            let n = name.text!
            let d = descrip.text!
            var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("createView2") as UIViewController
            createNavController.pushViewController(v, animated: true)
            nameInput = n
            descriptionInput = d
        //}
    }
    
    func clickAction(sender:UIButton!) {
        buttonImg.alpha = 0.1
    }
    
    func dragAction(sender:UIButton!) {
        buttonImg.alpha = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

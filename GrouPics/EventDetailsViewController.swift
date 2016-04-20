//
//  EventDetailsViewController.swift
//  GrouPics
//
//  Created by Andrew on 4/12/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

var alert = UIAlertController()
var passwordString : String = String()
var passwordAttempt: UITextField = UITextField()
class EventDetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nameLabel = UILabel()
        let title = eventName.componentsSeparatedByString("^")[0]
        let count = title.characters.count
        nameLabel.backgroundColor = UIColor.lightGrayColor()
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.text = title
        nameLabel.textAlignment = .Center
        nameLabel.font = UIFont(name: "Menlo", size: (50 - CGFloat(count)) * (screenSize.width/375))
        nameLabel.frame = CGRectMake(0, 0, screenSize.width, screenSize.height * 0.12)
        nameLabel.frame.origin.x = (screenSize.width - nameLabel.frame.size.width)/2
        //nameLabel.frame.origin.y = (screenSize.height - nameLabel.frame.size.height)/2
        nameLabel.frame.origin.y = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.sharedApplication().statusBarFrame.size.height//(screenSize.height * 0.1)
        nameLabel.alpha = 0.7
        
        let eventRef = dataBase.childByAppendingPath("events/" + eventName)
        let picturesRef = eventRef.childByAppendingPath("cover photo/")
        var pictureString : String = String()
        var pic : UIImage = UIImage()
        let image = UIImageView()
        image.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        image.frame.origin.x = (screenSize.width - image.frame.size.width)/2
        image.frame.origin.y = (screenSize.height - image.frame.size.height)/2
        picturesRef.observeEventType(.Value, withBlock: { snapshot in
            
            pictureString = snapshot.value as! String
            if pictureString != "" {
                let pictureData = NSData(base64EncodedString: pictureString, options:NSDataBase64DecodingOptions(rawValue: 0))
                pic = UIImage(data: pictureData!)!
                image.image = pic
                
                //self.view.backgroundColor = UIColor(patternImage: pic)
                
            }
        })
        
        let button = UIButton()
        button.titleLabel!.font = UIFont(name: "Arial", size: 21*screenSize.width/320)
        button.setTitle("Join Event", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.lightGrayColor()
        button.frame = CGRectMake(0, 0, screenSize.width * 0.5, screenSize.height * 0.1)
        button.frame.origin.x = (screenSize.width - button.frame.size.width)
        button.frame.origin.y = (screenSize.height - button.frame.size.height - 50)
        button.alpha = 0.7
        
        button.addTarget(self, action: #selector(EventDetailsViewController.joinAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(image)
        self.view.addSubview(nameLabel)
        self.view.addSubview(button)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func joinAction(sender:UIButton!) {
        
        let eventRef = dataBase.childByAppendingPath("events/" + eventName)
        let passwordRef = eventRef.childByAppendingPath("password/")
        let userRef = dataBase.childByAppendingPath("users/" + userID)
        let userEventsRef = userRef.childByAppendingPath("joined events/" + eventName)
        passwordRef.observeEventType(.Value, withBlock: { snapshot in
            passwordString = snapshot.value as! String
            if passwordString != "" {
                let actionSheetController: UIAlertController = UIAlertController(title: "Join Event", message: "Please enter the password", preferredStyle: .Alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) {action -> Void in
                }
                actionSheetController.addAction(cancelAction)
                
                actionSheetController.addTextFieldWithConfigurationHandler{textField -> Void in
                    //textField.textColor = UIColor.blueColor()
                    textField.placeholder = "password"
                    textField.secureTextEntry = true
                    passwordAttempt = textField
                }
                
                let nextAction: UIAlertAction = UIAlertAction(title: "Next", style: .Default) {action -> Void in
                    
                    if (passwordAttempt.text == passwordString) {
                        //print("You are in")
                        userEventsRef.setValue(eventName)
                        self.tabBarController!.selectedIndex = 2
                        eventsNavLocal = 1
                        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("searchEventsView") as UIViewController
                        searchEventsNavController.pushViewController(v, animated: true)
                    }
                    else {
                        let alert = UIAlertView()
                        alert.title = "Incorrect Password"
                        alert.message = "Try again or confirm with your host"
                        alert.addButtonWithTitle("Understood")
                        alert.show()
                    }
                }
                actionSheetController.addAction(nextAction)
                self.presentViewController(actionSheetController, animated: true, completion: nil)
                print("You need a damn password")
                print(passwordAttempt)
            }
            else {
                //print("You are in")
                userEventsRef.setValue(eventName)
                self.tabBarController!.selectedIndex = 2
                eventsNavLocal = 1
                var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("searchEventsView") as UIViewController
                searchEventsNavController.pushViewController(v, animated: true)
            }

        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
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


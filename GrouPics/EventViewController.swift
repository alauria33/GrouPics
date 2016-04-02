//
//  EventViewController.swift
//  GrouPics
//
//  Created by Andrew on 3/27/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit
import Firebase

class EventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var name: UILabel!
    override func viewDidLoad() {
        UIApplication.sharedApplication().statusBarHidden = false
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        // Do any additional setup after loading the view.
        let upload = UIButton(type: UIButtonType.System) as UIButton
        upload.setBackgroundImage(UIImage(named: "uploadPlus.png"), forState: UIControlState.Normal)
        upload.frame = CGRectMake(0, 0, screenSize.width * 0.12, screenSize.width*0.12)
        upload.frame.origin.x = (screenSize.width - upload.frame.size.width)*0.95
        upload.frame.origin.y = (screenSize.height - upload.frame.size.height)*0.12
        upload.tintColor = UIColor.whiteColor()
        upload.addTarget(self, action: "uploadPhoto:", forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(upload)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        ref = Firebase(url:"https://groupics333.firebaseio.com/")
        var eventName : String = String()
        if picked == 1 {
            let userRef = ref.childByAppendingPath("users/" + userID)
            userRef.observeEventType(.Value, withBlock: { snapshot in
                eventName = snapshot.value.objectForKey("hosted events") as! String
                print("name is " + eventName)
                self.name.text = eventName
                }, withCancelBlock: { error in
                    print(error.description)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadPhoto(sender: AnyObject) {
        var pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("image selected")
        tempImg = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        self.dismissViewControllerAnimated(true, completion: nil)
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        tempView = storyboard.instantiateViewControllerWithIdentifier("eventUploadView") as UIViewController
        self.navigationController?.pushViewController(tempView, animated: false)
    }
    

}

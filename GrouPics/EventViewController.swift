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

    let img = UIImageView()
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
        
        img.frame = CGRectMake(0, 0, screenSize.width * 0.42, screenSize.height * 0.318)
        img.frame.origin.x = (screenSize.width - img.frame.size.width)*0.8
        img.frame.origin.y = (screenSize.height - img.frame.size.height)*0.5
        //let grayColor = UIColor(red: 137/255, green: 140/255, blue: 145/255, alpha: 1.0)
        let grayColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.5)
        img.backgroundColor = grayColor
        self.view.addSubview(img)
        
        var pictureString : String = String()
        if picked == 1 {
            self.name.text = eventName
            let eventRef = dataBase.childByAppendingPath("events/" + eventName)
            eventRef.observeEventType(.Value, withBlock: { snapshot in
                pictureString = snapshot.value.objectForKey("picture") as! String
                if pictureString != "" {
                    let pictureData = NSData(base64EncodedString: pictureString, options:NSDataBase64DecodingOptions(rawValue: 0))
                    self.img.image =  UIImage(data: pictureData!)
                }
                }, withCancelBlock: { error in
                    print(error.description)
            })
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
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

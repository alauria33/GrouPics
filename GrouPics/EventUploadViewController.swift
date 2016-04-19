//
//  EventUploadViewController.swift
//  GrouPics
//
//  Created by Andrew on 3/29/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit
import Firebase

class EventUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    let img: UIImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("screen width: \(screenSize.width), height: \(screenSize.height)")
        print("pic width: \(tempImg.size.width), height: \(tempImg.size.height)")
        img.frame.size.width = screenSize.width
        img.frame.size.height = screenSize.width * (tempImg.size.height/tempImg.size.width)
        img.frame.origin.x = (screenSize.width - img.frame.size.width)/2
        img.frame.origin.y = (screenSize.height - img.frame.size.height)/2
        img.image = tempImg
        self.view.addSubview(img)
        print("img width: \(img.frame.size.width), height: \(img.frame.size.height)")
        print("pic width: \(tempImg.size.width), height: \(tempImg.size.height)")
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarHidden = true
        tabBarController?.tabBar.hidden = true
        let circle : UIImage? = UIImage(named:"circle")
        
        let buttonLabel: UILabel = UILabel()
        let darkGray = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0)
        buttonLabel.backgroundColor = darkGray
        buttonLabel.frame = CGRectMake(0, 0, screenSize.width, screenSize.height * 0.11)
        buttonLabel.frame.origin.x = (screenSize.width - buttonLabel.frame.size.width)/2
        buttonLabel.frame.origin.y = (screenSize.height)*0.89
        buttonLabel.alpha = 1.0
        self.view.addSubview(buttonLabel)
        
        let upl = UIButton(type: UIButtonType.System) as UIButton
        upl.titleLabel!.font = UIFont(name: "Menlo", size: 18)
        upl.frame = CGRectMake(0, 0, screenSize.width * 0.3, screenSize.height * 0.05)
        upl.frame.origin.x = (screenSize.width - upl.frame.size.width)*0.95
        upl.frame.origin.y = buttonLabel.frame.origin.y + (buttonLabel.frame.size.height - upl.frame.size.height)*0.5
        upl.setTitle("Use Photo", forState: UIControlState.Normal)
        upl.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        upl.addTarget(self, action: "uploadAction:", forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(upl)
        
        let reselect = UIButton(type: UIButtonType.System) as UIButton
        reselect.titleLabel!.font = UIFont(name: "Menlo", size: 16)
        reselect.frame = CGRectMake(0, 0, screenSize.width * 0.35, screenSize.height * 0.05)
        reselect.frame.origin.x = (screenSize.width - reselect.frame.size.width)*0.05
        reselect.frame.origin.y = buttonLabel.frame.origin.y + (buttonLabel.frame.size.height - upl.frame.size.height)*0.5
        reselect.setTitle("Choose Again", forState: UIControlState.Normal)
        reselect.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        reselect.addTarget(self, action: "reselectAction:", forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(reselect)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func uploadAction(sender:UIButton!) {
        temp = 1
        self.navigationController?.navigationBarHidden = true
        tabBarController?.tabBar.hidden = false
        UIApplication.sharedApplication().statusBarHidden = false
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        tempView = storyboard.instantiateViewControllerWithIdentifier("eventsView") as UIViewController
        self.navigationController?.pushViewController(tempView, animated: false)
        eventsNavLocal = 1
        let eventRef = dataBase.childByAppendingPath("events/" + eventName)
        let countRef = eventRef.childByAppendingPath("picture count/")
        countRef.runTransactionBlock({
            (currentData:FMutableData!) in
            var value = currentData.value as? Int
            if (value == nil) {
                value = 0
            }
            currentData.value = value! + 1
            return FTransactionResult.successWithValue(currentData)
        })
        let indexRef = eventRef.childByAppendingPath("picture index/")
        indexRef.runTransactionBlock({
            (currentData:FMutableData!) in
            var value = currentData.value as? Int
            if (value == nil) {
                value = 0
            }
            else {
                if self.img.image != nil {
                    let tempImg = self.img.image!.lowestQualityJPEGNSData
                    //let imgData: NSData = UIImageJPEGRepresentation(self.img.image!, 1.0)!
                    let pictureInput = tempImg.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                    let tempRef = eventRef.childByAppendingPath("pictures/\(value!)")
                    tempRef.setValue(pictureInput)
                    let tempRef2 = eventRef.childByAppendingPath("picture owners/\(value!)")
                    tempRef2.setValue(userID)
                }
            }
            currentData.value = value! + 1
            return FTransactionResult.successWithValue(currentData)
        })
    
    }
    
    func reselectAction(sender:UIButton!) {
        var pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        tempImg = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        self.dismissViewControllerAnimated(true, completion: nil)
        img.image = tempImg
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

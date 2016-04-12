//
//  EventUploadViewController.swift
//  GrouPics
//
//  Created by Andrew on 3/29/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit
import Firebase

class EventUploadViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        img.image = tempImg
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarHidden = true
        tabBarController?.tabBar.hidden = true
        let circle : UIImage? = UIImage(named:"circle")
        let upl   = UIButton(type: UIButtonType.System) as UIButton
        upl.titleLabel!.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
        upl.frame = CGRectMake(0, 0, screenSize.width * 0.43, screenSize.height * 0.14)
        upl.frame.origin.x = (screenSize.width - upl.frame.size.width)/2
        upl.frame.origin.y = (screenSize.height - upl.frame.size.height)*0.84
        upl.setTitle("Upload", forState: UIControlState.Normal)
        let blueColor = UIColor(red: 136/255, green: 175/255, blue: 239/255, alpha: 1.0)
        upl.setTitleColor(blueColor, forState: UIControlState.Normal)
        upl.setBackgroundImage(circle, forState: UIControlState.Normal)
        upl.addTarget(self, action: "uploadAction:", forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(upl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func uploadAction(sender:UIButton!) {
        temp = 1
//        tabBarController!.selectedIndex = 2
//        tabBarController!.selectedIndex = 3
        self.navigationController?.navigationBarHidden = true
        tabBarController?.tabBar.hidden = false
        UIApplication.sharedApplication().statusBarHidden = false
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        tempView = storyboard.instantiateViewControllerWithIdentifier("eventsView") as UIViewController
        self.navigationController?.pushViewController(tempView, animated: false)
        tempView = storyboard.instantiateViewControllerWithIdentifier("eventView") as UIViewController
        self.navigationController?.pushViewController(tempView, animated: false)
        let eventRef = dataBase.childByAppendingPath("events/" + eventName)
        
        let countRef = eventRef.childByAppendingPath("picture count/")
        countRef.runTransactionBlock({
            (currentData:FMutableData!) in
            var value = currentData.value as? Int
            if (value == nil) {
                value = 0
            }
            currentData.value = value! + 1
            if self.img.image != nil {
                let imgData: NSData = UIImageJPEGRepresentation(self.img.image!, 1.0)!
                let pictureInput = imgData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                let tempRef = eventRef.childByAppendingPath("pictures/\(value!)")
                tempRef.setValue(pictureInput)
            }
            return FTransactionResult.successWithValue(currentData)
        })
    
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

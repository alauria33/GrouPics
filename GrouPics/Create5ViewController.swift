//
//  Create4ViewController.swift
//  GrouPics
//
//  Created by Andrew on 3/28/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit
import Firebase
import GeoFire
import CoreLocation

class Create5ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var img : UIImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        let selPhoto = UIButton(type: UIButtonType.System) as UIButton
        selPhoto.titleLabel!.font = UIFont(name: "Arial", size: 14*screenSize.width/320)
        selPhoto.frame = CGRectMake(0, 0, screenSize.width * 0.3, screenSize.height * 0.1)
        selPhoto.frame.origin.x = (screenSize.width - selPhoto.frame.size.width)*0.12
        selPhoto.frame.origin.y = (screenSize.height - selPhoto.frame.size.height)*0.5
        selPhoto.setTitle("Select Photo", forState: UIControlState.Normal)
        let darkColor = UIColor(red: 46/255, green: 106/255, blue: 202/255, alpha: 1.0)
        selPhoto.setTitleColor(darkColor, forState: UIControlState.Normal)
        selPhoto.addTarget(self, action: "selectPhoto:", forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(selPhoto)
        
        // Do any additional setup after loading the view.
        let circle : UIImage? = UIImage(named:"circle")
        let create   = UIButton(type: UIButtonType.System) as UIButton
        create.titleLabel!.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
        create.frame = CGRectMake(0, 0, screenSize.width * 0.43, screenSize.height * 0.14)
        create.frame.origin.x = (screenSize.width - create.frame.size.width)/2
        create.frame.origin.y = (screenSize.height - create.frame.size.height)*0.84
        create.setTitle("Create Event", forState: UIControlState.Normal)
        let blueColor = UIColor(red: 136/255, green: 175/255, blue: 239/255, alpha: 1.0)
        create.setTitleColor(blueColor, forState: UIControlState.Normal)
        create.setBackgroundImage(circle, forState: UIControlState.Normal)
        create.addTarget(self, action: "createAction:", forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(create)
        img = UIImageView()
        img.frame = CGRectMake(0, 0, screenSize.width * 0.42, screenSize.height * 0.318)
        img.frame.origin.x = (screenSize.width - img.frame.size.width)*0.8
        img.frame.origin.y = (screenSize.height - img.frame.size.height)*0.5
        //let grayColor = UIColor(red: 137/255, green: 140/255, blue: 145/255, alpha: 1.0)
        let grayColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.5)
        img.backgroundColor = grayColor
        self.view.addSubview(img)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createAction(sender:UIButton!) {
        picked = 1
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("createView1") as UIViewController
        createNavController.pushViewController(v, animated: false)
        var eventRef = dataBase.childByAppendingPath("events/")
//        let geoFire = GeoFire(firebaseRef: eventRef)
//        geoFire.setLocation(CLLocation(latitude: latitudeInput, longitude: longitudeInput), forKey: nameInput)
        eventRef = dataBase.childByAppendingPath("events/" + nameInput)
        var tempRef = eventRef.childByAppendingPath("name/")
        tempRef.setValue(nameInput)
        tempRef = eventRef.childByAppendingPath("description/")
        tempRef.setValue(descriptionInput)
        tempRef = eventRef.childByAppendingPath("password/")
        tempRef.setValue(passwordInput)
        let usersRef = dataBase.childByAppendingPath("users/" + userID + "/hosted events")
        usersRef.setValue(nameInput)
        temp = 1
        tabBarController!.selectedIndex = 3
        
        let locationRef = dataBase.childByAppendingPath("locations/")
        let geoFire = GeoFire(firebaseRef: locationRef)
        geoFire.setLocation(CLLocation(latitude: latitudeInput, longitude: longitudeInput), forKey: nameInput)
        
//        geoFire.getLocationForKey(nameInput, withCallback: { (location, error) in
//            if (error != nil) {
//                print("An error occurred getting the location")
//            } else if (location != nil) {
//                print("Location for \"firebase-hq\" is [\(location.coordinate.latitude), \(location.coordinate.longitude)]")
//            } else {
//                print("GeoFire does not contain a location for \"firebase-hq\"")
//            }
//        })
    }
    
    @IBAction func selectPhoto(sender: AnyObject) {
        var pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        img.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
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

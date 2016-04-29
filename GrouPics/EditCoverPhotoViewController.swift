//
//  SetPhotoViewController.swift
//  GrouPics
//
//  Created by Thomas Weng on 4/28/16.
//  Copyright © 2016 Andrew. All rights reserved.
//
import UIKit
class EditCoverPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var img : UIImageView = UIImageView()
    let eventRef = dataBase.childByAppendingPath("events/" + eventName)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor() //veryDullRedColor
        titleLabel.text = "Change event cover photo?"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Menlo-Bold", size: 25*screenSize.width/375)
        titleLabel.frame = CGRectMake(0, 0, screenSize.width, screenSize.height * 0.3)
        titleLabel.frame.origin.x = (screenSize.width - titleLabel.frame.size.width)/2
        titleLabel.frame.origin.y = (screenSize.height - titleLabel.frame.size.height)*0.1
        titleLabel.alpha = 1.0
        self.view.addSubview(titleLabel)
        
        let selPhoto = UIButton(type: UIButtonType.System) as UIButton
        selPhoto.titleLabel!.font = UIFont(name: "Arial", size: 14*screenSize.width/320)
        selPhoto.frame = CGRectMake(0, 0, screenSize.width * 0.3, screenSize.height * 0.1)
        selPhoto.frame.origin.x = (screenSize.width - selPhoto.frame.size.width)*0.12
        selPhoto.frame.origin.y = (screenSize.height - selPhoto.frame.size.height)*0.5
        selPhoto.setTitle("Select Photo", forState: UIControlState.Normal)
        let darkColor = UIColor(red: 201/255, green: 47/255, blue: 0/255, alpha: 1.0)
        selPhoto.setTitleColor(darkColor, forState: UIControlState.Normal)
        selPhoto.addTarget(self, action: "selectPhoto:", forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(selPhoto)
        
        
        let picturesRef = eventRef.childByAppendingPath("cover photo/")
        var pictureString : String = String()
        var pic : UIImage = UIImage()
        
        img = UIImageView()
        img.frame = CGRectMake(0, 0, screenSize.width * 0.35, screenSize.height * 0.32)
        img.frame.origin.x = (screenSize.width - img.frame.size.width)*0.8
        img.frame.origin.y = (screenSize.height - img.frame.size.height)*0.5
        //let grayColor = UIColor(red: 137/255, green: 140/255, blue: 145/255, alpha: 1.0)
        let grayColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.5)
        img.backgroundColor = grayColor
        
        picturesRef.observeEventType(.Value, withBlock: { snapshot in
            
            pictureString = snapshot.value as! String
            if pictureString != "" {
                let pictureData = NSData(base64EncodedString: pictureString, options:NSDataBase64DecodingOptions(rawValue: 0))
                pic = UIImage(data: pictureData!)!
                self.img.image = pic
                
                //self.view.backgroundColor = UIColor(patternImage: pic)
                
            }
        })
        self.view.addSubview(img)
        
        let save = UIButton()
        save.titleLabel!.font = UIFont(name: "Cantabile", size: 16*screenSize.width/320)
        save.setTitle("Save Cover Photo", forState: UIControlState.Normal)
        save.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        save.backgroundColor = UIColor(red: 135/255, green: 20/255, blue: 0/255, alpha: 1.0)
        save.frame = CGRectMake(0, 0, screenSize.width * 0.5, screenSize.height * 0.1)
        save.frame.origin.x = screenSize.width - save.frame.size.width
        save.frame.origin.y = img.frame.origin.y + img.frame.height + 60
        save.alpha = 1.0
        
        save.addTarget(self, action: "saveAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(save)
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
    
    func saveAction(sender:UIButton!) {
        eventsNavController.popViewControllerAnimated(true)
        var tempRef = eventRef.childByAppendingPath("cover photo/")
        if img.image != nil {
            let imgData = UIImageJPEGRepresentation(img.image!, 0.0)!
            let pictureInput = imgData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            tempRef.setValue(pictureInput)
        }
        else {
            tempRef.setValue("")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
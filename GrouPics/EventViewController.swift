//
//  EventViewController.swift
//  GrouPics
//
//  Created by Andrew on 3/27/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit
import Firebase

var viewingPicture: UIImage = UIImage()

class EventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //var query: GFCircleQuery!
//    let img = UIImageView()
    @IBOutlet weak var name: UILabel!
    var scrollView: UIScrollView!
    var count: Int = 0
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
        
        let eventRef = dataBase.childByAppendingPath("events/" + eventName)
        
        self.name.text = eventName
        
//        img.frame = CGRectMake(0, 0, screenSize.width * 0.42, screenSize.height * 0.318)
//        img.frame.origin.x = (screenSize.width - img.frame.size.width)*0.8
//        img.frame.origin.y = (screenSize.height - img.frame.size.height)*0.5
//        //let grayColor = UIColor(red: 137/255, green: 140/255, blue: 145/255, alpha: 1.0)
//        let grayColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.5)
//        img.backgroundColor = grayColor
//        self.view.addSubview(img)
//        var pictureString : String = String()
//        eventRef.observeEventType(.Value, withBlock: { snapshot in
//            pictureString = snapshot.value.objectForKey("cover photo") as! String
//            if pictureString != "" {
//                let pictureData = NSData(base64EncodedString: pictureString, options:NSDataBase64DecodingOptions(rawValue: 0))
//                self.img.image =  UIImage(data: pictureData!)
//            }
//            }, withCancelBlock: { error in
//                print(error.description)
//        })
        
        let diff: CGFloat = 5
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.lightGrayColor()
        scrollView.autoresizingMask = [.FlexibleRightMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleTopMargin]
        scrollView.frame = CGRectMake(0, 0, screenSize.width*0.8 + 3.5 * diff, screenSize.height*0.6)
        scrollView.frame.origin.x = (screenSize.width - scrollView.frame.width)*0.5
        scrollView.frame.origin.y = (screenSize.height - scrollView.frame.height)*0.62
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, screenSize.height*2)
        self.view.addSubview(scrollView)
        var pictureString : String = String()
        var yPos: CGFloat = diff
        var xPos: CGFloat = diff
        let picturesRef = eventRef.childByAppendingPath("pictures/")
        picturesRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            print("count" + "\(self.count)")
            pictureString = snapshot.value as! String
            let button = UIButton()
            if pictureString != "" {
                let pictureData = NSData(base64EncodedString: pictureString, options:NSDataBase64DecodingOptions(rawValue: 0))
                button.setImage(UIImage(data: pictureData!), forState: UIControlState.Normal)
                button.frame = CGRectMake(0, 0, (self.scrollView.frame.width - 3.5 * diff)/4, self.scrollView.frame.height/3.7)
                button.frame.origin.x = xPos
                button.frame.origin.y = yPos
                button.layer.cornerRadius = 10
                button.addTarget(self, action: #selector(EventViewController.pictureClick(_:)), forControlEvents:UIControlEvents.TouchUpInside)
                if self.count == 3 {
                    self.count = 0
                    xPos = diff
                    yPos = yPos + self.scrollView.frame.width/2.8
                }
                else {
                    xPos = xPos + (self.scrollView.frame.width - 3.5 * diff)/4 + diff/2
                    self.count = self.count + 1
                }
                self.scrollView.addSubview(button)
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pictureClick(sender: UIButton) {
        print("here")
        viewingPicture = (sender.imageView?.image)!
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("pictureView") as UIViewController
        eventsNavController.pushViewController(v, animated: true)
    }
    
    @IBAction func uploadPhoto(sender: AnyObject) {
        var pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        tempImg = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        self.dismissViewControllerAnimated(true, completion: nil)
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        tempView = storyboard.instantiateViewControllerWithIdentifier("eventUploadView") as UIViewController
        self.navigationController?.pushViewController(tempView, animated: false)
    }
    

}

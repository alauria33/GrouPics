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
var picCount: Int!
var currentPictureValue: Int!

class EventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //var query: GFCircleQuery!
//    let img = UIImageView()
    @IBOutlet weak var name: UILabel!
    var scrollView: UIScrollView!
    var count: Int = 0
    var fromCamera : Bool = false
    let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    let emptyLabel : UILabel = UILabel()
    let picsPerRow: CGFloat = 4
    var tempCount = 0
    
    override func viewDidLoad() {
        UIApplication.sharedApplication().statusBarHidden = false
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        // Do any additional setup after loading the view.
        
        let upload = UIButton(type: UIButtonType.System) as UIButton
        upload.setBackgroundImage(UIImage(named: "gallery.png"), forState: UIControlState.Normal)
        upload.frame.size.width = (self.navigationController?.navigationBar.frame.size.width)!/14
        upload.frame.size.height = upload.frame.size.width
        upload.frame.origin.x = ((self.navigationController?.navigationBar.frame.size.width)! - upload.frame.size.width) * 0.9
        upload.frame.origin.y = ((self.navigationController?.navigationBar.frame.size.height)! - upload.frame.size.height)/2
        upload.addTarget(self, action: "uploadPhoto:", forControlEvents:UIControlEvents.TouchUpInside)
        
        let camera = UIButton(type: UIButtonType.System) as UIButton
        camera.setBackgroundImage(UIImage(named: "album.png"), forState: UIControlState.Normal)
        camera.frame.size.width = (self.navigationController?.navigationBar.frame.size.width)!/14
        camera.frame.size.height = camera.frame.size.width
        camera.frame.origin.x = ((self.navigationController?.navigationBar.frame.size.width)! - camera.frame.size.width) * 0.9
        camera.frame.origin.y = ((self.navigationController?.navigationBar.frame.size.height)! - camera.frame.size.height)/2
        camera.addTarget(self, action: "takePhoto:", forControlEvents:UIControlEvents.TouchUpInside)
        
        let settings = UIButton(type: UIButtonType.System) as UIButton
        settings.setBackgroundImage(UIImage(named: "settings.png"), forState: UIControlState.Normal)
        settings.frame.size.width = (self.navigationController?.navigationBar.frame.size.width)!/14
        settings.frame.size.height = camera.frame.size.width
        settings.frame.origin.x = ((self.navigationController?.navigationBar.frame.size.width)! - settings.frame.size.width) * 0.9
        settings.frame.origin.y = ((self.navigationController?.navigationBar.frame.size.height)! - settings.frame.size.height)/2
        settings.addTarget(self, action: "settings:", forControlEvents:UIControlEvents.TouchUpInside)
        
        var uploadBarButtonItem:UIBarButtonItem = UIBarButtonItem()
        uploadBarButtonItem.customView = upload
        let space = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        space.width = (self.navigationController?.navigationBar.frame.size.width)!/21.5
        var cameraBarButtonItem:UIBarButtonItem = UIBarButtonItem()
        cameraBarButtonItem.customView = camera
        var settingsBarButtonItem:UIBarButtonItem = UIBarButtonItem()
        settingsBarButtonItem.customView = settings
        // 3
        self.navigationItem.setRightBarButtonItems([uploadBarButtonItem, space, cameraBarButtonItem, space, space, space, space, space, settingsBarButtonItem], animated: true)
        let eventRef = dataBase.childByAppendingPath("events/" + eventName)
        let hostRef = eventRef.childByAppendingPath("host/")
        hostRef.observeEventType(.Value, withBlock: { snapshot in
            let host = snapshot.value as! String
            if host != userID {
                print("not host")
                settingsBarButtonItem.customView = UIButton()
            }
        })
        
        let titleLabel = UILabel()
        let lightRed = UIColor(red: 225/255, green: 92/255, blue: 92/255, alpha: 1.0)
        let brightRed = UIColor(red: 222/255, green: 38/255, blue: 38/255, alpha: 1.0)
        let lightBlue = UIColor(red: 173/255, green: 191/255, blue: 219/255, alpha: 1.0)
        let deepBlue = UIColor(red: 98/255, green: 144/255, blue: 220/255, alpha: 1.0)
        let skyBlue = UIColor(red: 60/255, green: 170/255, blue: 255/255, alpha: 1.0)
        let deepRed = UIColor(red: 255/255, green: 69/255, blue: 60/255, alpha: 1.0)
        let veryDeepRed = UIColor(red: 255/255, green: 18/255, blue: 6/255, alpha: 1.0)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = eventName.componentsSeparatedByString("^")[0]

        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Menlo-Bold", size: 35*screenSize.width/375)
        titleLabel.frame = CGRectMake(0, 0, screenSize.width, screenSize.height * 0.15)
        titleLabel.frame.origin.x = (screenSize.width - titleLabel.frame.size.width)/2
        titleLabel.frame.origin.y = (screenSize.height - titleLabel.frame.size.height)*0.1
        titleLabel.alpha = 1.0
        self.view.addSubview(titleLabel)
        
        
        let diff: CGFloat = 5
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.lightGrayColor()
        scrollView.autoresizingMask = [.FlexibleRightMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleTopMargin]
        scrollView.frame = CGRectMake(0, 0, screenSize.width*0.88 + (2 + 0.5 * (picsPerRow-1)) * diff, screenSize.height*0.65)
        scrollView.frame.origin.x = (screenSize.width - scrollView.frame.width)*0.5
        scrollView.frame.origin.y = screenSize.height*0.23
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, diff)
        self.view.addSubview(scrollView)
        
        activityIndicator.frame = CGRectMake(0, 0, screenSize.width/2, screenSize.width/2)
        activityIndicator.frame.origin.x = (scrollView.frame.size.width - activityIndicator.frame.size.width)/2
        activityIndicator.frame.origin.y = (scrollView.frame.size.height - activityIndicator.frame.size.height)/2.1
        activityIndicator.startAnimating()
        activityIndicator.transform = CGAffineTransformMakeScale(4, 4)
        activityIndicator.hidesWhenStopped = true
        scrollView.addSubview(activityIndicator)
        
        var pictureString : String = String()
        var yPos: CGFloat = diff
        var xPos: CGFloat = diff
        let picturesRef = eventRef.childByAppendingPath("pictures/")
        self.tempCount = 0
        
        picturesRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            pictureString = snapshot.value as! String
            let button = UIButton()
            let index = pictureString.startIndex
            if pictureString != "" {
                let pictureData = NSData(base64EncodedString: pictureString, options:NSDataBase64DecodingOptions(rawValue: 0))
                let btnImg = UIImage(data: pictureData!)
                button.setImage(UIImage(data: pictureData!), forState: UIControlState.Normal)
                button.frame = CGRectMake(0, 0, (self.scrollView.frame.width - (2 + 0.5 * (self.picsPerRow-1)) * diff)/self.picsPerRow, 0)
                button.frame.size.height = 0.9 * button.frame.size.width * (btnImg!.size.height/btnImg!.size.width)
                button.frame.origin.x = xPos
                button.frame.origin.y = yPos
                button.layer.cornerRadius = 10
                if (btnImg!.size.height/btnImg!.size.width) != 1334/750 {
                    button.frame.origin.y += (0.9 * button.frame.size.width * ((screenSize.height/screenSize.width) - (btnImg!.size.height/btnImg!.size.width)))/2
                    //add background
                    let backGround1 = UIButton()
                    backGround1.backgroundColor = UIColor.blackColor()
                    backGround1.frame = CGRectMake(0, 0, (self.scrollView.frame.width - (2 + 0.5 * (self.picsPerRow-1)) * diff)/self.picsPerRow, 0)
                    backGround1.frame.size.height = (0.9 * button.frame.size.width * ((screenSize.height/screenSize.width) - (btnImg!.size.height/btnImg!.size.width)))/2
                    backGround1.frame.origin.y -= (0.9 * button.frame.size.width * ((screenSize.height/screenSize.width) - (btnImg!.size.height/btnImg!.size.width)))/2
                    button.addSubview(backGround1)
                    let backGround2 = UIButton()
                    backGround2.backgroundColor = UIColor.blackColor()
                    backGround2.frame = CGRectMake(0, 0, (self.scrollView.frame.width - (2 + 0.5 * (self.picsPerRow-1)) * diff)/self.picsPerRow, 0)
                    backGround2.frame.size.height = (0.9 * button.frame.size.width * ((screenSize.height/screenSize.width) - (btnImg!.size.height/btnImg!.size.width)))/2
                    backGround2.frame.origin.y = button.frame.size.height
                    button.addSubview(backGround2)
                }
                let fullBtnHeight = 0.9 * button.frame.size.width * (screenSize.height/screenSize.width)
                button.setTitle(snapshot.key, forState: UIControlState.Normal)
                button.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
                button.addTarget(self, action: #selector(EventViewController.pictureClick(_:)), forControlEvents:UIControlEvents.TouchUpInside)
                if self.count == 0 {
                    self.scrollView.contentSize.height += fullBtnHeight + diff
                }
                if self.count == Int(self.picsPerRow - 1) {
                    self.count = 0
                    xPos = diff
                    yPos = yPos + fullBtnHeight + diff
                }
                else {
                    xPos = xPos + (self.scrollView.frame.width - (2 + 0.5 * (self.picsPerRow-1)) * diff)/self.picsPerRow + diff/2
                    self.count = self.count + 1
                }
                self.scrollView.insertSubview(button, atIndex: 10)
            }
            self.activityIndicator.stopAnimating()
        })

        picturesRef.observeEventType(.ChildRemoved, withBlock: { snapshot in
            let subViews = self.scrollView.subviews
            for subview in subViews{
                subview.removeFromSuperview()
            }
            self.count = 0
            xPos = diff
            yPos = diff
            picturesRef.observeEventType(.ChildAdded, withBlock: { snapshot in
                pictureString = snapshot.value as! String
                let button = UIButton()
                let index = pictureString.startIndex
                if pictureString != "" {
                    let pictureData = NSData(base64EncodedString: pictureString, options:NSDataBase64DecodingOptions(rawValue: 0))
                    let btnImg = UIImage(data: pictureData!)
                    button.setImage(UIImage(data: pictureData!), forState: UIControlState.Normal)
                    button.frame = CGRectMake(0, 0, (self.scrollView.frame.width - (2 + 0.5 * (self.picsPerRow-1)) * diff)/self.picsPerRow, 0)
                    button.frame.size.height = 0.9 * button.frame.size.width * (btnImg!.size.height/btnImg!.size.width)
                    button.frame.origin.x = xPos
                    button.frame.origin.y = yPos
                    button.layer.cornerRadius = 10
                    if (btnImg!.size.height/btnImg!.size.width) != 1334/750 {
                        button.frame.origin.y += (0.9 * button.frame.size.width * ((screenSize.height/screenSize.width) - (btnImg!.size.height/btnImg!.size.width)))/2
                        //add background
                        let backGround1 = UIButton()
                        backGround1.backgroundColor = UIColor.blackColor()
                        backGround1.frame = CGRectMake(0, 0, (self.scrollView.frame.width - (2 + 0.5 * (self.picsPerRow-1)) * diff)/self.picsPerRow, 0)
                        backGround1.frame.size.height = (0.9 * button.frame.size.width * ((screenSize.height/screenSize.width) - (btnImg!.size.height/btnImg!.size.width)))/2
                        backGround1.frame.origin.y -= (0.9 * button.frame.size.width * ((screenSize.height/screenSize.width) - (btnImg!.size.height/btnImg!.size.width)))/2
                        button.addSubview(backGround1)
                        let backGround2 = UIButton()
                        backGround2.backgroundColor = UIColor.blackColor()
                        backGround2.frame = CGRectMake(0, 0, (self.scrollView.frame.width - (2 + 0.5 * (self.picsPerRow-1)) * diff)/self.picsPerRow, 0)
                        backGround2.frame.size.height = (0.9 * button.frame.size.width * ((screenSize.height/screenSize.width) - (btnImg!.size.height/btnImg!.size.width)))/2
                        backGround2.frame.origin.y = button.frame.size.height
                        button.addSubview(backGround2)
                    }
                    let fullBtnHeight = 0.9 * button.frame.size.width * (screenSize.height/screenSize.width)
                    button.setTitle(snapshot.key, forState: UIControlState.Normal)
                    button.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
                    button.addTarget(self, action: #selector(EventViewController.pictureClick(_:)), forControlEvents:UIControlEvents.TouchUpInside)
                    if self.count == 0 {
                        self.scrollView.contentSize.height += fullBtnHeight + diff
                    }
                    if self.count == Int(self.picsPerRow - 1) {
                        self.count = 0
                        xPos = diff
                        yPos = yPos + fullBtnHeight + diff
                    }
                    else {
                        xPos = xPos + (self.scrollView.frame.width - (2 + 0.5 * (self.picsPerRow-1)) * diff)/self.picsPerRow + diff/2
                        self.count = self.count + 1
                    }
                    self.scrollView.insertSubview(button, atIndex: 10)
                }
                self.activityIndicator.stopAnimating()
            })
        })
        
        self.emptyLabel.textColor = UIColor.clearColor()
        self.emptyLabel.text = "empty"
        self.emptyLabel.textAlignment = .Center
        self.emptyLabel.font = UIFont(name: "Menlo-Bold", size:20*screenSize.width/375)
        self.emptyLabel.frame = CGRectMake(0, 0, screenSize.width, screenSize.height * 0.15)
        self.emptyLabel.frame.origin.x = (self.scrollView.frame.size.width - self.emptyLabel.frame.size.width)/2
        self.emptyLabel.frame.origin.y = (self.scrollView.frame.size.height - self.emptyLabel.frame.size.height)/2
        self.emptyLabel.alpha = 1.0
        self.scrollView.addSubview(self.emptyLabel)
        
        let countValRef = dataBase.childByAppendingPath("events/" + eventName + "/picture count")
        countValRef.observeEventType(.Value, withBlock: { snapshot in
            let c: Int = (snapshot.value as? Int)!
            if c == 0 {
                self.activityIndicator.stopAnimating()
                self.emptyLabel.textColor = UIColor.grayColor()
            }
            else {
                self.emptyLabel.textColor = UIColor.clearColor()
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.alpha = 1.0
        self.navigationController?.navigationBarHidden = false
        tabBarController!.tabBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pictureClick(sender: UIButton) {
        currentPictureValue = Int((sender.titleLabel?.text)!)
        print(currentPictureValue)
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
        fromCamera = false
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        var pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
        fromCamera = true
    }
    
    @IBAction func settings(sender: AnyObject) {
        print("settingS")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        tempImg = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        self.dismissViewControllerAnimated(true, completion: nil)
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if fromCamera {
            let img = UIImageView()
            img.image = tempImg
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
                    if img.image != nil {
                        let tempImg = img.image!.lowestQualityJPEGNSData
                        //let imgData: NSData = UIImageJPEGRepresentation(img.image!, 1.0)!
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
        else {
            tempView = storyboard.instantiateViewControllerWithIdentifier("eventUploadView") as UIViewController
            self.navigationController?.pushViewController(tempView, animated: false)
        }
        
    }

}

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
    let slideShow = UIButton()
    let slideShowImage: UIImageView = UIImageView()
    let slideShowOptionsButton: UIButton = UIButton()
    let slideShowBackground: UIImageView = UIImageView()
    var slideShowTimer: NSTimer = NSTimer()
    var slideShowCount: Int = 4
    let slideShowPausedLabel: UILabel = UILabel()
    let slideShowOptionsLabel: UILabel = UILabel()
    let slideShowOptionsClose: UIButton = UIButton()
    let slideShowOptionsPlay: UIButton = UIButton()
    let slideShowOptionsSave: UIButton = UIButton()
    var slideShowOptionsOn: Int = 0
    
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
                settingsBarButtonItem.customView = UIButton()
            }
        })
        
        let titleLabel = UILabel()
        let lightRed = UIColor(red: 225/255, green: 92/255, blue: 92/255, alpha: 1.0)
        let brightRed = UIColor(red: 222/255, green: 38/255, blue: 38/255, alpha: 1.0)
        let lightBlue = UIColor(red: 173/255, green: 191/255, blue: 219/255, alpha: 1.0)
        let deepBlue = UIColor(red: 98/255, green: 144/255, blue: 220/255, alpha: 1.0)
        let skyBlue = UIColor(red: 60/255, green: 170/255, blue: 255/255, alpha: 1.0)
        let deepRed = UIColor(red: 195/255, green: 45/255, blue: 45/255, alpha: 1.0)
        let veryDeepRed = UIColor(red: 255/255, green: 18/255, blue: 6/255, alpha: 1.0)
        let dullRedColor = UIColor(red: 193/255.0, green: 113/255.0, blue: 104/255.0, alpha: 1.0)
        let veryDullRedColor = UIColor(red: 210/255.0, green: 132/255.0, blue: 132/255.0, alpha: 1.0)

        titleLabel.textColor = UIColor.whiteColor() //veryDullRedColor
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
        let heightDiff = screenSize.height/13
        scrollView.frame.size.height -= heightDiff
        scrollView.frame.origin.y += heightDiff
        
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
            self.slideShow.alpha = 1.0
            self.slideShow.userInteractionEnabled = true
            
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
                self.slideShow.alpha = 1.0
                self.slideShow.userInteractionEnabled = true
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
                self.slideShow.alpha = 1.0
                self.slideShow.userInteractionEnabled = true
                self.emptyLabel.textColor = UIColor.grayColor()
            }
            else {
                self.emptyLabel.textColor = UIColor.clearColor()
            }
        })
        
        let darkRedColor = UIColor(red: 109/255.0, green: 32/255.0, blue: 24/255.0, alpha: 1.0)
    
        slideShow.titleLabel!.font = UIFont(name: "Menlo", size: 17*screenSize.width/320) //Chalkboard SE
        slideShow.setTitle("View SlideShow", forState: UIControlState.Normal)
        slideShow.setTitleColor(darkRedColor, forState: UIControlState.Normal)
        slideShow.backgroundColor = UIColor.whiteColor()
        slideShow.frame = CGRectMake(0, 0, self.scrollView.frame.width*0.7, self.scrollView.frame.height*0.12)
        slideShow.frame.origin.x = (screenSize.width - slideShow.frame.width)*0.5
        slideShow.frame.origin.y =  scrollView.frame.origin.y - screenSize.height/12
        slideShow.layer.cornerRadius = 10
        slideShow.addTarget(self, action: "slideshow:", forControlEvents: UIControlEvents.TouchUpInside)
        slideShow.addTarget(self, action: "slideshowHeld:", forControlEvents: UIControlEvents.TouchDown)
        slideShow.layer.borderWidth = 2
        slideShow.layer.borderColor = darkRedColor.CGColor
        slideShow.alpha = 0.6
        slideShow.userInteractionEnabled = false
        self.view.addSubview(slideShow)
        
        
        slideShowBackground.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        slideShowBackground.backgroundColor = UIColor.blackColor()
        slideShowBackground.frame.origin.x = 0
        slideShowBackground.frame.origin.y = 0
        
        slideShowImage.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        slideShowImage.frame.origin.x = (screenSize.width - slideShowImage.frame.width)*0.5
        slideShowImage.frame.origin.y =  (screenSize.height - slideShowImage.frame.height)*0.5
        
        let darkGray = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0)
        slideShowOptionsLabel.backgroundColor = darkGray
        slideShowOptionsLabel.frame = CGRectMake(0, 0, screenSize.width, screenSize.height * 0.11)
        slideShowOptionsLabel.frame.origin.x = (screenSize.width - slideShowOptionsLabel.frame.size.width)/2
        slideShowOptionsLabel.frame.origin.y = (screenSize.height)*0.89
        
        slideShowPausedLabel.text = "PAUSED"
        slideShowPausedLabel.textAlignment = .Center
        slideShowPausedLabel.backgroundColor = darkGray
        slideShowPausedLabel.layer.masksToBounds = true
        slideShowPausedLabel.layer.cornerRadius = 10
        slideShowPausedLabel.textColor = UIColor.whiteColor()
        slideShowPausedLabel.font = UIFont(name: "Menlo-Bold", size: 28*screenSize.width/375)
        slideShowPausedLabel.frame = CGRectMake(0, 0, screenSize.width/2, screenSize.height * 0.11)
        slideShowPausedLabel.frame.origin.x = (screenSize.width - slideShowPausedLabel.frame.size.width)/2
        slideShowPausedLabel.frame.origin.y = (screenSize.height - slideShowPausedLabel.frame.size.height)*0.4
        
//        slideShowOptionsButton.frame = CGRectMake(0, 0, screenSize.width, screenSize.height - slideShowOptionsLabel.frame.size.height)
//        slideShowOptionsButton.frame.origin.x = 0
//        slideShowOptionsButton.frame.origin.y = 0
//        slideShowOptionsButton.userInteractionEnabled = true
//        slideShowOptionsButton.addTarget(self, action: "slideshowOptions:", forControlEvents: UIControlEvents.TouchDown)
        
        slideShowOptionsButton.backgroundColor = darkGray
        slideShowOptionsButton.layer.masksToBounds = true
        slideShowOptionsButton.layer.cornerRadius = 10
        slideShowOptionsButton.setImage(UIImage(named: "pause.png"), forState: UIControlState.Normal)
        slideShowOptionsButton.addTarget(self, action: "slideshowOptions:", forControlEvents: UIControlEvents.TouchDown)
        slideShowOptionsButton.frame = CGRectMake(0, 0, screenSize.width/5, screenSize.height * 0.11)
        slideShowOptionsButton.frame.origin.x = (screenSize.width - slideShowOptionsButton.frame.size.width)/2
        slideShowOptionsButton.frame.origin.y = (screenSize.height - slideShowOptionsButton.frame.size.height*0.9)
        slideShowOptionsButton.imageEdgeInsets = UIEdgeInsetsMake(15,20,20,20)//UIEdgeInsetsMake(screenSize.width/15,screenSize.width/10,screenSize.width/15,screenSize.width/10)

        slideShowOptionsSave.titleLabel!.font = UIFont(name: "Menlo", size: 18)
        slideShowOptionsSave.frame = CGRectMake(0, 0, screenSize.width * 0.07, screenSize.width * 0.07)
        slideShowOptionsSave.frame.origin.x = (screenSize.width - slideShowOptionsSave.frame.size.width)*0.05
        slideShowOptionsSave.frame.origin.y = slideShowOptionsLabel.frame.origin.y + (slideShowOptionsLabel.frame.size.height - slideShowOptionsSave.frame.size.height)*0.5
        slideShowOptionsSave.setImage(UIImage(named: "save2"), forState: UIControlState.Normal)
        slideShowOptionsSave.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        slideShowOptionsSave.addTarget(self, action: "ssSave:", forControlEvents:UIControlEvents.TouchUpInside)
        
        slideShowOptionsClose.titleLabel!.font = UIFont(name: "Menlo", size: 18)
        slideShowOptionsClose.frame = CGRectMake(0, 0, screenSize.width * 0.3, screenSize.height * 0.05)
        slideShowOptionsClose.frame.origin.x = (screenSize.width - slideShowOptionsClose.frame.size.width)
        slideShowOptionsClose.frame.origin.y = slideShowOptionsLabel.frame.origin.y + (slideShowOptionsLabel.frame.size.height - slideShowOptionsClose.frame.size.height)*0.5
        slideShowOptionsClose.setTitle("Close", forState: UIControlState.Normal)
        slideShowOptionsClose.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        slideShowOptionsClose.addTarget(self, action: "ssClose:", forControlEvents:UIControlEvents.TouchUpInside)
        
        slideShowOptionsPlay.titleLabel!.font = UIFont(name: "Menlo", size: 18)
        slideShowOptionsPlay.frame = CGRectMake(0, 0, screenSize.width * 0.1, screenSize.width * 0.1)
        slideShowOptionsPlay.frame.origin.x = (screenSize.width - slideShowOptionsPlay.frame.size.width)*0.5
        slideShowOptionsPlay.frame.origin.y = slideShowOptionsLabel.frame.origin.y + (slideShowOptionsLabel.frame.size.height - slideShowOptionsPlay.frame.size.height)*0.5
        slideShowOptionsPlay.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
        slideShowOptionsPlay.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        slideShowOptionsPlay.addTarget(self, action: "ssPlay:", forControlEvents:UIControlEvents.TouchUpInside)

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
                        let imgData = UIImageJPEGRepresentation(img.image!, 0.0)!
                        let pictureInput = imgData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
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
    
    func slideshowHeld(sender:Button!) {
        sender.alpha = 0.6
    }
    
    func slideshow(sender:Button!) {
        sender.alpha = 1.0
        if scrollView.subviews.count >= 5 {
            self.view.addSubview(slideShowBackground)
            self.view.addSubview(slideShowImage)
            let btn = scrollView.subviews[slideShowCount++] as! UIButton
            slideShowImage.image = btn.currentImage
            slideShowTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "slideShowUpdate", userInfo: nil, repeats: true)
            self.view.addSubview(slideShowOptionsButton)
            slideShow.userInteractionEnabled = false
            scrollView.userInteractionEnabled = false
            self.navigationController?.navigationBarHidden = true
            tabBarController?.tabBar.hidden = true
            UIApplication.sharedApplication().statusBarHidden = true
        }
    }
    
    func slideShowUpdate() {
        var btn: UIButton!
        if slideShowCount > scrollView.subviews.count - 1 {
            slideShowCount = 4
            ssClose(nil)
        }
        else {
        print("count: \(slideShowCount)")
        // if statements protect from reordering of children
        if let temp = scrollView.subviews[slideShowCount] as? UIButton {
            btn = scrollView.subviews[slideShowCount++] as! UIButton
        }
        else if let temp = scrollView.subviews[slideShowCount] as? UIButton {
            btn = scrollView.subviews[slideShowCount++] as! UIButton
        }
        else if let temp = scrollView.subviews[slideShowCount] as? UIButton {
            btn = scrollView.subviews[slideShowCount++] as! UIButton
        }
        else if let temp = scrollView.subviews[slideShowCount] as? UIButton {
            btn = scrollView.subviews[slideShowCount++] as! UIButton
        }
        slideShowImage.image = btn.currentImage
        slideShowImage.frame.size.height = screenSize.width * (btn.currentImage!.size.height/btn.currentImage!.size.width)
        slideShowImage.frame.origin.y = (screenSize.height - slideShowImage.frame.size.height)/2
        }
    }
    
    func slideshowOptions(sender:Button!) {
        print("options")
        if slideShowOptionsOn == 0 {
            slideShowTimer.invalidate()
            self.view.addSubview(slideShowOptionsLabel)
            self.view.addSubview(slideShowPausedLabel)
            self.view.addSubview(slideShowOptionsClose)
            self.view.addSubview(slideShowOptionsPlay)
            self.view.addSubview(slideShowOptionsSave)
            slideShowOptionsOn = 1
        }
        else {
            slideShowTimer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: "slideShowUpdate", userInfo: nil, repeats: true)
            slideShowOptionsLabel.removeFromSuperview()
            slideShowPausedLabel.removeFromSuperview()
            slideShowOptionsClose.removeFromSuperview()
            slideShowOptionsPlay.removeFromSuperview()
            slideShowOptionsSave.removeFromSuperview()
            slideShowOptionsOn = 0
        }
    }
    
    func ssPlay(sender:Button!) {
        slideShowTimer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: "slideShowUpdate", userInfo: nil, repeats: true)
        slideShowOptionsLabel.removeFromSuperview()
        slideShowOptionsClose.removeFromSuperview()
        slideShowPausedLabel.removeFromSuperview()
        slideShowOptionsPlay.removeFromSuperview()
        slideShowOptionsSave.removeFromSuperview()
        slideShowOptionsOn = 0
    }
    
    func ssSave(sender:Button!) {
        UIImageWriteToSavedPhotosAlbum(slideShowImage.image!, nil, nil, nil)
    }
    
    func ssClose(sender:Button!) {
        slideShowTimer.invalidate()
        slideShowOptionsLabel.removeFromSuperview()
        slideShowOptionsClose.removeFromSuperview()
        slideShowOptionsPlay.removeFromSuperview()
        slideShowOptionsSave.removeFromSuperview()
        slideShowBackground.removeFromSuperview()
        slideShowPausedLabel.removeFromSuperview()
        slideShowOptionsButton.removeFromSuperview()
        slideShowImage.removeFromSuperview()
        slideShowOptionsOn = 0
        slideShow.userInteractionEnabled = true
        scrollView.userInteractionEnabled = true
        self.navigationController?.navigationBarHidden = false
        tabBarController?.tabBar.hidden = false
        UIApplication.sharedApplication().statusBarHidden = false
    }

}

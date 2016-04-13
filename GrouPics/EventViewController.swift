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
        
        let diff: CGFloat = 5
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.lightGrayColor()
        scrollView.autoresizingMask = [.FlexibleRightMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleTopMargin]
        scrollView.frame = CGRectMake(0, 0, screenSize.width*0.88 + 3.5 * diff, screenSize.height*0.65)
        scrollView.frame.origin.x = (screenSize.width - scrollView.frame.width)*0.5
        scrollView.frame.origin.y = (screenSize.height - scrollView.frame.height)*0.69
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, diff)
        self.view.addSubview(scrollView)
        var pictureString : String = String()
        var yPos: CGFloat = diff
        var xPos: CGFloat = diff
        let picturesRef = eventRef.childByAppendingPath("pictures/")
        picturesRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            pictureString = snapshot.value as! String
            let button = UIButton()
            if pictureString != "" {
                let pictureData = NSData(base64EncodedString: pictureString, options:NSDataBase64DecodingOptions(rawValue: 0))
                button.setImage(UIImage(data: pictureData!), forState: UIControlState.Normal)
                button.frame = CGRectMake(0, 0, (self.scrollView.frame.width - 3.5 * diff)/4, 0)
                button.frame.size.height = 0.9 * button.frame.size.width * (screenSize.height/screenSize.width)
                button.frame.origin.x = xPos
                button.frame.origin.y = yPos
                button.layer.cornerRadius = 10
                button.addTarget(self, action: #selector(EventViewController.pictureClick(_:)), forControlEvents:UIControlEvents.TouchUpInside)
                print(self.count)
                if self.count == 0 {
                    
                    self.scrollView.contentSize.height += button.frame.size.height + diff
//                    print(button.frame.size.height)
//                    print(self.scrollView.contentSize.height)
//                    print(self.scrollView.frame.size.height)
                }
                if self.count == 3 {
                    self.count = 0
                    xPos = diff
                    yPos = yPos + button.frame.size.height + diff
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
        tabBarController!.tabBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pictureClick(sender: UIButton) {
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

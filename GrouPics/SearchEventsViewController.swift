//
//  SecondViewController.swift
//  GrouPics
//
//  Created by Andrew on 3/26/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit
import Firebase
import GeoFire


class SearchEventsViewController: UIViewController, CLLocationManagerDelegate {
    
    var curLocation : CLLocation = CLLocation()
    var latitude : Double = Double()
    var longitude : Double = Double()
    
    var containerView = UIView()
    let locationManager = CLLocationManager()
    var locValue: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var scrollView: UIScrollView!
    var theView: UIView!
    
    var query: GFCircleQuery!
    
    var buttonCount : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
         theView=UIView(frame: CGRectMake(100, 200, 100, 100))
         theView.backgroundColor=UIColor.greenColor()
         theView.layer.cornerRadius=25
         theView.layer.borderWidth=2*/
        
        // scrollView.addSubview(theView)
        
        //let firebaseRef = Firebase(url:"https://groupics333.firebaseio.com/locations")
        let geoFire = GeoFire(firebaseRef: Firebase(url:"https://groupics333.firebaseio.com").childByAppendingPath("locations"))
        
        
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let darkGreenColor = UIColor(red: 19/255.0, green: 35/255.0, blue: 19/255.0, alpha: 1.0)
        let lightGreenColor = UIColor(red: 199/255.0, green: 215/255.0, blue: 198/255.0, alpha: 1.0)
        let lightOrangeColor = UIColor(red: 232/255.0, green: 180/255.0, blue: 80/255.0, alpha: 1.0)
        let lightWhiteColor = UIColor(red: 246/255.0, green: 242/255.0, blue: 234/255.0, alpha: 1.0)
        let darkOrangeColor = UIColor(red: 159/255.0, green: 108/255.0, blue: 8/255.0, alpha: 1.0)
        let darkRedColor = UIColor(red: 109/255.0, green: 32/255.0, blue: 24/255.0, alpha: 1.0)

        scrollView = UIScrollView()
        scrollView.backgroundColor = lightGreenColor
        scrollView.autoresizingMask = [.FlexibleRightMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleTopMargin]
        scrollView.frame = CGRectMake(0, 0, screenSize.width*0.8, screenSize.height*0.6)
        scrollView.frame.origin.x = (screenSize.width - scrollView.frame.width)*0.5
        scrollView.frame.origin.y = (screenSize.height - scrollView.frame.height)*0.62
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, screenSize.height*2)
        
        buttonCount = 0

        var yPos: CGFloat = 20
//        curLocation = CLLocation(latitude: 37.3375, longitude: -122.041)
        query = geoFire.queryAtLocation(curLocation, withRadius: 1.609)
        query.observeEventType(.KeyEntered, withBlock: {
            (key: String!, location: CLLocation!) in
            //print("Key '\(key)' entered the search area and is at location '\(location)'")
            //let frame1 = CGRectMake(scrollView.frame.width*0.5, yPos, 200, 45)
            //let button   = UIButton(type: UIButtonType.System) as UIButton
            let button = UIButton()
            button.titleLabel!.font = UIFont(name: "ChalkboardSE-Bold", size: 21*screenSize.width/320)
            button.setTitle(key, forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            if (self.buttonCount % 2 == 0) {
                button.backgroundColor = darkOrangeColor//UIColor.whiteColor()
            }
            else if (self.buttonCount % 2 == 1) {
                button.backgroundColor = darkRedColor//UIColor.whiteColor()
            }
            button.frame = CGRectMake(0, 0, self.scrollView.frame.width*0.8, self.scrollView.frame.height*0.15)
            button.frame.origin.x = (self.scrollView.frame.width - button.frame.width)*0.5
            button.frame.origin.y = yPos
            button.layer.cornerRadius = 10
            yPos = yPos + button.frame.size.height + screenSize.height/60
            
            self.scrollView.addSubview(button)
            self.buttonCount = self.buttonCount + 1
            print(self.buttonCount)
            
        })
        
        self.view.addSubview(scrollView)
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
        curLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        query.center = curLocation
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.scrollEnabled = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
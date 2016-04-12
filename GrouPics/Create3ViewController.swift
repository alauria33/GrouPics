//
//  Create3ViewController.swift
//  GrouPics
//
//  Created by Andrew on 3/28/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GeoFire

var latitudeInput : Double = Double()
var longitudeInput : Double = Double()

class Create3ViewController: UIViewController, CLLocationManagerDelegate {

    let mySwitch = UISwitch() as UISwitch
    let map: MKMapView = MKMapView()
    let locationManager = CLLocationManager()
    var locValue: CLLocationCoordinate2D = CLLocationCoordinate2D()
    let buttonImg = UIImageView()
    //@IBOutlet weak var mySwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mySwitch.frame = CGRectMake(0, 0, screenSize.width * 0.3, screenSize.height * 0.09)
        mySwitch.frame.origin.x = (screenSize.width - mySwitch.frame.size.width)*0.75
        mySwitch.frame.origin.y = (screenSize.height - mySwitch.frame.size.height)*0.32
        mySwitch.tintColor = UIColor(red: 71/255, green: 153/255, blue: 255/255, alpha: 1.0)
        mySwitch.onTintColor = UIColor(red: 46/255, green: 106/255, blue: 202/255, alpha: 1.0)
        mySwitch.on = false
        //self.view.addSubview(mySwitch)
        
        let tv = UITextView()
        tv.frame = CGRectMake(0, 0, screenSize.width*0.85, screenSize.height * 0.15)
        tv.frame.origin.x = (screenSize.width - tv.frame.size.width)/2
        tv.frame.origin.y = (screenSize.height - tv.frame.size.height)*0.36
        tv.backgroundColor = UIColor.clearColor()
        let sampleText = "Using your current location..."
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Justified
        let attributedString = NSAttributedString(string: sampleText,
                                                  attributes: [
                                                    NSParagraphStyleAttributeName: paragraphStyle,
                                                    NSBaselineOffsetAttributeName: NSNumber(float: 0)
            ])
        tv.attributedText = attributedString
        tv.font = UIFont(name: "Arial", size: 15)
        tv.userInteractionEnabled = false
        self.view.addSubview(tv)
        
        let changeLoc = UIButton(type: UIButtonType.System) as UIButton
        changeLoc.titleLabel!.font = UIFont(name: "Arial", size: 14*screenSize.width/320)
        changeLoc.frame = CGRectMake(0, 0, screenSize.width * 0.45, screenSize.height * 0.1)
        changeLoc.frame.origin.x = (screenSize.width - changeLoc.frame.size.width)*0.88
        changeLoc.frame.origin.y = tv.frame.origin.y - screenSize.height/40//(screenSize.height - selPhoto.frame.size.height)*0.32
        changeLoc.setTitle("change", forState: UIControlState.Normal)
        let darkColor = UIColor(red: 46/255, green: 106/255, blue: 202/255, alpha: 1.0)
        changeLoc.setTitleColor(darkColor, forState: UIControlState.Normal)
        changeLoc.addTarget(self, action: "changeLocation:", forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(changeLoc)
        
        let circle : UIImage? = UIImage(named:"circle")
        let next   = UIButton(type: UIButtonType.System) as UIButton
        next.titleLabel!.font = UIFont(name: "ChalkboardSE-Bold", size: 21)
        next.frame = CGRectMake(0, 0, screenSize.width * 0.3, screenSize.height * 0.09)
        next.frame.origin.x = (screenSize.width - next.frame.size.width)/2
        next.frame.origin.y = (screenSize.height - next.frame.size.height)*0.82
        next.setTitle("Next", forState: UIControlState.Normal)
        let blueColor = UIColor(red: 136/255, green: 175/255, blue: 239/255, alpha: 1.0)
        let lightBlueColor = UIColor(red: 50/255, green: 70/255, blue: 147/255, alpha: 1.0)
        next.setTitleColor(lightBlueColor, forState: UIControlState.Normal)
        //next.setBackgroundImage(circle, forState: UIControlState.Normal)
        next.addTarget(self, action: #selector(Create3ViewController.nextAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        next.addTarget(self, action: #selector(CreateViewController.clickAction(_:)), forControlEvents: UIControlEvents.TouchDown)
        next.addTarget(self, action: #selector(CreateViewController.dragAction(_:)), forControlEvents: UIControlEvents.TouchDragExit)
        buttonImg.frame = CGRectMake(0, 0, next.frame.size.width/1.3, next.frame.size.width/1.6)
        buttonImg.frame.origin.x = (screenSize.width - buttonImg.frame.size.width)/1.95
        buttonImg.frame.origin.y = (next.frame.origin.y + screenSize.height/42)
        //let grayColor = UIColor(red: 137/255, green: 140/255, blue: 145/255, alpha: 1.0)
        buttonImg.image = UIImage(named: "arrow")
        self.view.addSubview(buttonImg)
        self.view.addSubview(next)
        
        mySwitch.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
        mySwitch.on = true
        map.frame = CGRectMake(0, 0, screenSize.width * 0.7, screenSize.height * 0.34)
        map.frame.origin.x = (screenSize.width - map.frame.size.width)/2
        map.frame.origin.y = (screenSize.height - map.frame.size.height)/1.8
        self.view.addSubview(map)
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
        let center = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: true)
    }
    
    func switchChanged(sender:UISwitch!) {
        if mySwitch.on {
            self.view.addSubview(map)
        }
        else {
            map.removeFromSuperview()
            
        }
    }
    
    func nextAction(sender:UIButton!) {
        buttonImg.alpha = 1.0
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("createView4") as UIViewController
        createNavController.pushViewController(v, animated: true)
//        let geoReg =
//        let tempRef = ref.childByAppendingPath("/location")
//        tempRef.setValue("\(locValue.latitude) \(locValue.longitude)")
        latitudeInput = locValue.latitude
        longitudeInput = locValue.longitude
    }
    
    func clickAction(sender:UIButton!) {
        buttonImg.alpha = 0.1
    }
    
    func dragAction(sender:UIButton!) {
        buttonImg.alpha = 1.0
    }

    func changeLocation(sender:UIButton!) {
        buttonImg.alpha = 1.0
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("mapsView") as UIViewController
        createNavController.pushViewController(v, animated: true)
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

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
class Create3ViewController: UIViewController, CLLocationManagerDelegate {

    let pw = UITextField() as UITextField
    let mySwitch = UISwitch() as UISwitch
    //@IBOutlet weak var mySwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("here???")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mySwitch.frame = CGRectMake(0, 0, screenSize.width * 0.3, screenSize.height * 0.09)
        mySwitch.frame.origin.x = (screenSize.width - mySwitch.frame.size.width)/2
        mySwitch.frame.origin.y = (screenSize.height - mySwitch.frame.size.height)*0.85
        mySwitch.tintColor = UIColor(red: 71/255, green: 153/255, blue: 255/255, alpha: 1.0)
        mySwitch.onTintColor = UIColor(red: 46/255, green: 106/255, blue: 202/255, alpha: 1.0)
        mySwitch.on = false
        self.view.addSubview(mySwitch)
        
        // Do any additional setup after loading the view.
        let tv = UITextView()
        tv.frame = CGRectMake(0, 0, screenSize.width*0.85, screenSize.height * 0.15)
        tv.frame.origin.x = (screenSize.width - tv.frame.size.width)*0.5
        tv.frame.origin.y = (screenSize.height - tv.frame.size.height)*0.36
        tv.backgroundColor = UIColor.clearColor()
        tv.text = "Use current location?"
        tv.font = UIFont(name: "Arial", size: 15)
        tv.userInteractionEnabled = false
        self.view.addSubview(tv)
        
        let circle : UIImage? = UIImage(named:"circle")
        let next   = UIButton(type: UIButtonType.System) as UIButton
        next.titleLabel!.font = UIFont(name: "ChalkboardSE-Bold", size: 21)
        next.frame = CGRectMake(0, 0, screenSize.width * 0.3, screenSize.height * 0.09)
        next.frame.origin.x = (screenSize.width - next.frame.size.width)/2
        next.frame.origin.y = (screenSize.height - next.frame.size.height)*0.82
        next.setTitle("Next", forState: UIControlState.Normal)
        let blueColor = UIColor(red: 136/255, green: 175/255, blue: 239/255, alpha: 1.0)
        next.setTitleColor(blueColor, forState: UIControlState.Normal)
        next.setBackgroundImage(circle, forState: UIControlState.Normal)
        next.addTarget(self, action: #selector(Create3ViewController.nextAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(next)
        
        mySwitch.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)

    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func switchChanged(sender:UISwitch!) {
        if mySwitch.on {
            pw.userInteractionEnabled = true
            pw.backgroundColor = UIColor.whiteColor()
        }
        else {
            pw.userInteractionEnabled = false
            pw.backgroundColor = UIColor.clearColor()
            pw.text = ""
        }
    }
    
    func nextAction(sender:UIButton!) {
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("createView4") as UIViewController
        createNavController.pushViewController(v, animated: true)
        
        let tempRef = ref.childByAppendingPath("/password")
        tempRef.setValue(pw.text)
        pw.userInteractionEnabled = false
        pw.backgroundColor = UIColor.clearColor()
        pw.text = ""
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

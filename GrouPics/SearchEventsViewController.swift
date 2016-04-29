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

var hostStrings = [String]()
var joinStrings = [String]()

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
    var pastButtonCount : Int!

    var removeLocalStrings = [String]()
    var removeEventStrings = [String]()
    var waitVal: Int = -1
    var detailsView: UIViewController = UIViewController()
    var searchNamesView: UIViewController = UIViewController()
    
    override func viewDidAppear(animated: Bool) {
        hostStrings = [String]()
        joinStrings = [String]()
        let hostRef = dataBase.childByAppendingPath("users/" + userID + "/hosted events/")
        hostRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            let str = snapshot.value as! String
            hostStrings.append(str)//.componentsSeparatedByString("^")[0])
        })
        
        let joinRef = dataBase.childByAppendingPath("users/" + userID + "/joined events/")
        joinRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            let str = snapshot.value as! String
            joinStrings.append(str)//.componentsSeparatedByString("^")[0])
            //            let subViews = self.scrollView.subviews
            //            for subview in subViews{
            //                subview.removeFromSuperview()
            //            }
            //            self.pastButtonCount = self.buttonCount
            //            self.buttonCount = 0
            //            yPos = 20
            //
            //            if self.pastButtonCount > 1 {
            //                let query3 = geoFire.queryAtLocation(self.curLocation, withRadius: 5000)
            //                query3.observeEventType(.KeyEntered, withBlock: {
            //                    (key: String!, location: CLLocation!) in
            //                    let title = key.componentsSeparatedByString("^")[0]
            //                    let notHost: Bool = (!hostStrings.contains(key)) && (lastHostedEvent != key)
            //                    let notJoin: Bool = !joinStrings.contains(key)
            //                    if notHost && notJoin {
            //                        let button = Button()
            //                        button.titleLabel!.font = UIFont(name: "Menlo", size: 21*screenSize.width/320)
            //                        button.setTitle(title, forState: UIControlState.Normal)
            //                        button.setTitleColor(lightWhiteColor, forState: UIControlState.Normal)
            //                        button.string = key
            //                        if (self.buttonCount % 2 == 0) {
            //                            button.backgroundColor = lightWhiteColor//dullOrangeColor
            //                            button.setTitleColor(normGreenColor, forState: UIControlState.Normal)
            //                        }
            //                        else if (self.buttonCount % 2 == 1) {
            //                            button.backgroundColor = leafGreenColor//UIColor.whiteColor()
            //                        }
            //                        button.frame = CGRectMake(0, 0, self.scrollView.frame.width*0.9, screenSize.height*0.09)
            //                        button.frame.origin.x = (self.scrollView.frame.width - button.frame.width)*0.5
            //                        button.frame.origin.y = yPos
            //                        button.layer.cornerRadius = 10
            //
            //                        button.addTarget(self, action: #selector(SearchEventsViewController.nextAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            //                        let yPosDiff = screenSize.height/60
            //                        yPos = yPos + button.frame.size.height + yPosDiff
            //
            //                        self.scrollView.addSubview(button)
            //                        self.buttonCount = self.buttonCount + 1
            //                        if self.buttonCount == self.pastButtonCount - 1 {
            //                            query3.removeAllObservers()
            //                        }
            //                        self.scrollView.contentSize.height = 20 + 20 + CGFloat(self.buttonCount)*(button.frame.size.height + yPosDiff)
            //                    }
            //                })
            //            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
         theView=UIView(frame: CGRectMake(100, 200, 100, 100))
         theView.backgroundColor=UIColor.greenColor()
         theView.layer.cornerRadius=25
         theView.layer.borderWidth=2*/
        
        // scrollView.addSubview(theView)
        
        //let timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "removeEvents", userInfo: nil, repeats: true)

        //let firebaseRef = Firebase(url:"https://groupics333.firebaseio.com/locations")
        let geoFire = GeoFire(firebaseRef: Firebase(url:"https://groupics333.firebaseio.com").childByAppendingPath("locations"))
        
        searchNamesView = storyboard!.instantiateViewControllerWithIdentifier("searchNamesView") as UIViewController
        detailsView = storyboard!.instantiateViewControllerWithIdentifier("eventDetailsView") as UIViewController
        
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
        let lightWhiteColor = UIColor(red: 249/255.0, green: 253/255.0, blue: 248/255.0, alpha: 1.0)
        let darkOrangeColor = UIColor(red: 159/255.0, green: 108/255.0, blue: 8/255.0, alpha: 1.0)
        let darkRedColor = UIColor(red: 109/255.0, green: 32/255.0, blue: 24/255.0, alpha: 1.0)
        let leafGreenColor = UIColor(red: 108/255.0, green: 177/255.0, blue: 115/255.0, alpha: 1.0)
        let dullOrangeColor = UIColor(red: 177/255.0, green: 145/255.0, blue: 108/255.0, alpha: 1.0)
        let normGreenColor = UIColor(red: 78/255.0, green: 155/255.0, blue: 86/255.0, alpha: 1.0)

        var yPos: CGFloat = 20
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.lightGrayColor()
        scrollView.autoresizingMask = [.FlexibleRightMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleTopMargin]
        scrollView.frame = CGRectMake(0, 0, screenSize.width*0.88 + (2 + 0.5 * (4-1)) * 5, screenSize.height*0.65)
        scrollView.frame.origin.x = (screenSize.width - scrollView.frame.width)*0.5
        scrollView.frame.origin.y = screenSize.height*0.23
        let diff = screenSize.height/5.5
        scrollView.frame.size.height -= diff
        scrollView.frame.origin.y += diff
        scrollView.contentSize.height = yPos

        let scrollLabelBackground = UILabel()
        scrollLabelBackground.backgroundColor = darkGreenColor
        scrollLabelBackground.frame = CGRectMake(0, 0, scrollView.frame.size.width, screenSize.height * 0.03)
        scrollLabelBackground.frame.origin.x = (screenSize.width  - scrollLabelBackground.frame.size.width)/2
        scrollLabelBackground.frame.origin.y = scrollView.frame.origin.y - scrollLabelBackground.frame.size.height
        self.view.addSubview(scrollLabelBackground)
        
        let scrollLabel = UILabel()
        scrollLabel.text = "events near you"
        scrollLabel.backgroundColor = darkGreenColor
        scrollLabel.textColor = UIColor.whiteColor()
        scrollLabel.textAlignment = .Center
        scrollLabel.font = UIFont(name: "Menlo", size: 16*screenSize.width/320)
        scrollLabel.frame = CGRectMake(0, 0, scrollView.frame.size.width, screenSize.height * 0.06)
        scrollLabel.frame.origin.x = (screenSize.width  - scrollLabel.frame.size.width)/2
        scrollLabel.frame.origin.y = scrollView.frame.origin.y - scrollLabel.frame.size.height
        scrollLabel.clipsToBounds = true
        scrollLabel.layer.cornerRadius = 10
        self.view.addSubview(scrollLabel)
        
        let searchBar = UIButton()
        searchBar.titleLabel!.font = UIFont(name: "Menlo", size: 21*screenSize.width/320) //Chalkboard SE
        searchBar.setTitle("search by name", forState: UIControlState.Normal)
        searchBar.setTitleColor(darkGreenColor, forState: UIControlState.Normal)
        searchBar.backgroundColor = UIColor.whiteColor()
        searchBar.frame = CGRectMake(0, 0, self.scrollView.frame.width*0.9, self.scrollView.frame.height*0.15)
        searchBar.frame.origin.x = (screenSize.width - searchBar.frame.width)*0.5
        searchBar.frame.origin.y =  scrollView.frame.origin.y - screenSize.height/5.5
        searchBar.layer.cornerRadius = 10
        searchBar.addTarget(self, action: "search:", forControlEvents: UIControlEvents.TouchUpInside)
        searchBar.addTarget(self, action: "searchHeld:", forControlEvents: UIControlEvents.TouchDown)

        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = leafGreenColor.CGColor
        self.view.addSubview(searchBar)
        
        buttonCount = 0
        
        query = geoFire.queryAtLocation(curLocation, withRadius: 5000)//1.609)
        query.observeEventType(.KeyEntered, withBlock: {
            (key: String!, location: CLLocation!) in
            let notHost: Bool = (!hostStrings.contains(key)) && (lastHostedEvent != key)
            let notJoin: Bool = !joinStrings.contains(key)
            if notHost && notJoin {
                let button = Button()
                let title = key.componentsSeparatedByString("^")[0]
                button.titleLabel!.font = UIFont(name: "Menlo", size: 21*screenSize.width/320) //Chalkboard SE
                button.setTitle(title, forState: UIControlState.Normal)
                button.setTitleColor(lightWhiteColor, forState: UIControlState.Normal)
                button.string = key
                if (self.buttonCount % 2 == 0) {
                    button.backgroundColor = lightWhiteColor//dullOrangeColor
                    button.setTitleColor(normGreenColor, forState: UIControlState.Normal)
                }
                else if (self.buttonCount % 2 == 1) {
                    button.backgroundColor = leafGreenColor//UIColor.whiteColor()
                }
                //
                button.frame = CGRectMake(0, 0, self.scrollView.frame.width*0.9, screenSize.height*0.09)
                button.frame.origin.x = (self.scrollView.frame.width - button.frame.width)*0.5
                button.frame.origin.y = yPos
                button.layer.cornerRadius = 10
                
                button.addTarget(self, action: #selector(SearchEventsViewController.nextAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                let yPosDiff = screenSize.height/60
                yPos = yPos + button.frame.size.height + yPosDiff

                self.scrollView.addSubview(button)
                self.buttonCount = self.buttonCount + 1
                self.scrollView.contentSize.height = 20 + CGFloat(self.buttonCount)*(button.frame.size.height + yPosDiff)
            }
            
        })
        
        query.observeEventType(.KeyExited, withBlock: {
            (key: String!, location: CLLocation!) in
            let subViews = self.scrollView.subviews
            for subview in subViews{
                subview.removeFromSuperview()
            }
            self.pastButtonCount = self.buttonCount
            self.buttonCount = 0
            yPos = 20
            if self.pastButtonCount > 1 {
                let query2 = geoFire.queryAtLocation(self.curLocation, withRadius: 5000)
                query2.observeEventType(.KeyEntered, withBlock: {
                    (key: String!, location: CLLocation!) in
                    let title = key.componentsSeparatedByString("^")[0]
                    let notHost: Bool = (!hostStrings.contains(key)) && (lastHostedEvent != key)
                    let notJoin: Bool = !joinStrings.contains(key)
                    if notHost && notJoin {
                        let button = Button()
                        button.titleLabel!.font = UIFont(name: "Menlo", size: 21*screenSize.width/320)
                        button.setTitle(title, forState: UIControlState.Normal)
                        button.setTitleColor(lightWhiteColor, forState: UIControlState.Normal)
                        button.string = key
                        if (self.buttonCount % 2 == 0) {
                            button.backgroundColor = lightWhiteColor//dullOrangeColor
                            button.setTitleColor(normGreenColor, forState: UIControlState.Normal)
                        }
                        else if (self.buttonCount % 2 == 1) {
                            button.backgroundColor = leafGreenColor//UIColor.whiteColor()
                        }
                        button.frame = CGRectMake(0, 0, self.scrollView.frame.width*0.9, screenSize.height*0.09)
                        button.frame.origin.x = (self.scrollView.frame.width - button.frame.width)*0.5
                        button.frame.origin.y = yPos
                        button.layer.cornerRadius = 10
                        
                        button.addTarget(self, action: #selector(SearchEventsViewController.nextAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                        let yPosDiff = screenSize.height/60
                        yPos = yPos + button.frame.size.height + yPosDiff
                        
                        self.scrollView.addSubview(button)
                        self.buttonCount = self.buttonCount + 1
                        if self.buttonCount == self.pastButtonCount - 1 {
                            query2.removeAllObservers()
                        }
                        self.scrollView.contentSize.height = 20 + 20 + CGFloat(self.buttonCount)*(button.frame.size.height + yPosDiff)
                    }
                })
            }
            self.view.addSubview(self.scrollView)
        })
        
        self.view.addSubview(scrollView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func nextAction(sender:Button!) {
        let statusRef = dataBase.childByAppendingPath("events/" + sender.string + "/status/")
        let endTimeRef = dataBase.childByAppendingPath("events/" + sender.string + "/end time/")
        endTimeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let str = snapshot.value as? String
            if str != nil {
                let eventDate = dateFormatter.dateFromString(str!)
                let date = NSDate()
                let calendar = NSCalendar.currentCalendar()
                var components = calendar.components(.Day, fromDate: date)
                let day = components.day
                components = calendar.components(.Month, fromDate: date)
                let month = components.month
                components = calendar.components(.Year, fromDate: date)
                let year = components.year
                components = calendar.components(.Hour, fromDate: date)
                let hour = components.hour
                components = calendar.components(.Minute, fromDate: date)
                let min = components.minute
                let timestamp: String = "\(day)-\(month)-\(year) \(hour):\(min)"
                let currentDate = dateFormatter.dateFromString(timestamp)
                if eventDate?.compare(currentDate!) == .OrderedAscending {
                    let localRef = dataBase.childByAppendingPath("/locations/\(sender.string)/")
                    localRef.removeValue()
                    statusRef.setValue("concluded")
                    let alert = UIAlertView()
                    alert.title = "Sorry"
                    alert.message = "This event has concluded"
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                }
                else {
                    searchEventsNavController.pushViewController(self.detailsView, animated: true)
                    eventName = sender.string
                }
            }
        })
    }
    
    func searchHeld(sender:Button!) {
        sender.alpha = 0.6
    }
    
    func search(sender:Button!) {
        sender.alpha = 1.0
        searchEventsNavController.pushViewController(self.searchNamesView, animated: true)
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
    
//    func removeEvents() {
//        for child in scrollView.subviews {
//            if let button = child as? Button {
//            let tempEventName = button.string
//            let endTimeRef = dataBase.childByAppendingPath("events/" + tempEventName + "/end time/")
//            endTimeRef.observeEventType(.Value, withBlock: { snapshot in
//                var dateFormatter = NSDateFormatter()
//                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
//                let str = snapshot.value as? String
//                if str != nil {
//                    let eventDate = dateFormatter.dateFromString(str!)
//                    let date = NSDate()
//                    let calendar = NSCalendar.currentCalendar()
//                    var components = calendar.components(.Day, fromDate: date)
//                    let day = components.day
//                    components = calendar.components(.Month, fromDate: date)
//                    let month = components.month
//                    components = calendar.components(.Year, fromDate: date)
//                    let year = components.year
//                    components = calendar.components(.Hour, fromDate: date)
//                    let hour = components.hour
//                    components = calendar.components(.Minute, fromDate: date)
//                    let min = components.minute
//                    let timestamp: String = "\(day)-\(month)-\(year) \(hour):\(min)"
//                    let currentDate = dateFormatter.dateFromString(timestamp)
//                    if eventDate?.compare(currentDate!) == .OrderedAscending {
//                        let oldRef = dataBase.childByAppendingPath("events/" + tempEventName)
//                        oldRef.observeEventType(.Value, withBlock: { snapshot in
//                            for child in snapshot.children {
//                                let newRef = dataBase.childByAppendingPath("concluded events/" + tempEventName + "/" + child.key)
//                                newRef.setValue(child.value)
//                            }
//                            let localRef = dataBase.childByAppendingPath("locations/" + tempEventName)
//                            localRef.removeValue()
//                            let activeRef = dataBase.childByAppendingPath("events/" + tempEventName)
//                            activeRef.removeValue()
//                        })
//                    }
//                }
//            })
//            }
//        }
//    }
    
}


import UIKit
import Firebase

class EventsViewController: UIViewController {

    var hostButtonCount : Int!
    var hostConcludedButtonCount : Int!
    var joinButtonCount : Int!
    var joinConcludedButtonCount : Int!
    var pastButtonCount : Int!
    
    var scrollView: UIScrollView!
    var scrollView2: UIScrollView!
    
    let scrollButton = UIButton()
    let scrollButton2 = UIButton()
    let scrollLabelBackground = UILabel()
    let scrollLabelBackground2 = UILabel()
    
    let darkRedColor = UIColor(red: 109/255.0, green: 32/255.0, blue: 24/255.0, alpha: 1.0)
    let darkGreenColor = UIColor(red: 19/255.0, green: 35/255.0, blue: 19/255.0, alpha: 1.0)
    let lightGreenColor = UIColor(red: 199/255.0, green: 215/255.0, blue: 198/255.0, alpha: 1.0)
    let lightOrangeColor = UIColor(red: 232/255.0, green: 180/255.0, blue: 80/255.0, alpha: 1.0)
    let lightWhiteColor = UIColor(red: 246/255.0, green: 242/255.0, blue: 234/255.0, alpha: 1.0)
    let darkOrangeColor = UIColor(red: 159/255.0, green: 108/255.0, blue: 8/255.0, alpha: 1.0)
    let dullPurpleColor = UIColor(red: 167/255.0, green: 147/255.0, blue: 174/255.0, alpha: 1.0)
    let dullRedColor = UIColor(red: 193/255.0, green: 113/255.0, blue: 104/255.0, alpha: 1.0)
    let dullYellowColor = UIColor(red: 219/255.0, green: 197/255.0, blue: 96/255.0, alpha: 1.0)
    let purplyRedColor = UIColor(red: 140/255.0, green: 91/255.0, blue: 107/255.0, alpha: 1.0)
    let dullOrangeColor = UIColor(red: 177/255.0, green: 145/255.0, blue: 108/255.0, alpha: 1.0)
    let orangyYellowColor = UIColor(red: 222/255.0, green: 174/255.0, blue: 122/255.0, alpha: 1.0)
    
    var yPos: CGFloat = 20
    var yPosConcluded: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "removeEvents", userInfo: nil, repeats: true)

        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.lightGrayColor()
        scrollView.autoresizingMask = [.FlexibleRightMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleTopMargin]
        scrollView.frame = CGRectMake(0, 0, screenSize.width*0.88 + (2 + 0.5 * (4-1)) * 5, screenSize.height*0.65)
        scrollView.frame.origin.x = (screenSize.width - scrollView.frame.width)*0.5
        scrollView.frame.origin.y = screenSize.height*0.23
        let diff = screenSize.height/14
        scrollView.frame.size.height -= diff
        scrollView.frame.origin.y += diff
        
        scrollView2 = UIScrollView()
        scrollView2.backgroundColor = UIColor.lightGrayColor()
        scrollView2.autoresizingMask = [.FlexibleRightMargin, .FlexibleLeftMargin, .FlexibleBottomMargin, .FlexibleTopMargin]
        scrollView2.frame = CGRectMake(0, 0, screenSize.width*0.88 + (2 + 0.5 * (4-1)) * 5, screenSize.height*0.65)
        scrollView2.frame.origin.x = (screenSize.width - scrollView2.frame.width)*0.5
        scrollView2.frame.origin.y = screenSize.height*0.23
        scrollView2.frame.size.height -= diff
        scrollView2.frame.origin.y += diff
        scrollView2.alpha = 0.0
        self.view.addSubview(scrollView2)
        
        scrollLabelBackground.backgroundColor = darkRedColor
        scrollLabelBackground.frame = CGRectMake(0, 0, scrollView.frame.size.width/1.5, screenSize.height * 0.03)
        scrollLabelBackground.frame.origin.x = scrollView.frame.origin.x
        scrollLabelBackground.frame.origin.y = scrollView.frame.origin.y - scrollLabelBackground.frame.size.height
        
        scrollLabelBackground2.backgroundColor = UIColor.whiteColor()
        scrollLabelBackground2.frame = CGRectMake(0, 0, scrollView.frame.size.width/1.5, screenSize.height * 0.03)
        scrollLabelBackground2.frame.origin.x = scrollView.frame.origin.x + scrollView.frame.size.width/3
        scrollLabelBackground2.frame.origin.y = scrollView.frame.origin.y - scrollLabelBackground2.frame.size.height

        scrollButton.setTitle("active", forState: UIControlState.Normal)
        scrollButton.backgroundColor = darkRedColor
        scrollButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        scrollButton.titleLabel?.textAlignment = .Center
        scrollButton.titleLabel?.font = UIFont(name: "Menlo", size: 16*screenSize.width/320)!
        scrollButton.frame = CGRectMake(0, 0, scrollView.frame.size.width/2, screenSize.height * 0.06)
        scrollButton.frame.origin.x = (screenSize.width  - scrollButton.frame.size.width)/2 - scrollView.frame.size.width/3.99
        scrollButton.frame.origin.y = scrollView.frame.origin.y - scrollButton.frame.size.height
        scrollButton.clipsToBounds = true
        scrollButton.layer.cornerRadius = 10
        scrollButton.addTarget(self, action: "activeAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        scrollButton2.setTitle("concluded", forState: UIControlState.Normal)
        scrollButton2.backgroundColor = UIColor.whiteColor()
        scrollButton2.setTitleColor(darkRedColor, forState: UIControlState.Normal)
        scrollButton2.titleLabel?.textAlignment = .Center
        scrollButton2.titleLabel?.font = UIFont(name: "Menlo", size: 16*screenSize.width/320)!
        scrollButton2.frame = CGRectMake(0, 0, scrollView.frame.size.width/2, screenSize.height * 0.06)
        scrollButton2.frame.origin.x = (screenSize.width  - scrollButton2.frame.size.width)/2 + scrollView.frame.size.width/3.99
        scrollButton2.frame.origin.y = scrollView.frame.origin.y - scrollButton2.frame.size.height
        scrollButton2.clipsToBounds = true
        scrollButton2.layer.cornerRadius = 10
        scrollButton2.addTarget(self, action: "concludedAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(scrollLabelBackground2)
        self.view.addSubview(scrollLabelBackground)
        self.view.addSubview(scrollButton)
        self.view.addSubview(scrollButton2)
        
        hostButtonCount = 0
        hostConcludedButtonCount = 0
        joinButtonCount = 0
        joinConcludedButtonCount = 0
        
        let joinRef = dataBase.childByAppendingPath("users/" + userID + "/joined events/")
        joinRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            let hostEventsName = snapshot.value as! String
            if hostEventsName != "null" {
                let button = Button()
                let title = hostEventsName.componentsSeparatedByString("^")[0]
                button.titleLabel!.font = UIFont(name: "Menlo", size: 21*screenSize.width/320) //Chalkboard SE
                button.setTitle(title, forState: UIControlState.Normal)
                button.setTitleColor(self.lightWhiteColor, forState: UIControlState.Normal)
                button.string = hostEventsName
                if ((self.hostButtonCount + self.joinButtonCount) % 2 == 0) {
                    button.backgroundColor = self.orangyYellowColor//dullPurpleColor//UIColor.whiteColor()
                }
                else if ((self.hostButtonCount + self.joinButtonCount) % 2 == 1) {
                    button.backgroundColor = self.dullRedColor//UIColor.whiteColor()
                }
                else if ((self.hostButtonCount + self.joinButtonCount) % 3 == 2) {
                    button.backgroundColor = self.lightOrangeColor//UIColor.whiteColor()
                }
                button.frame = CGRectMake(0, 0, self.scrollView.frame.width*0.9, screenSize.height*0.09)
                button.frame.origin.x = (self.scrollView.frame.width - button.frame.width)*0.5
                button.frame.origin.y = self.yPos
                button.layer.cornerRadius = 10
                
                button.addTarget(self, action: "eventAction:", forControlEvents: UIControlEvents.TouchUpInside)
                let yPosDiff = screenSize.height/60
                self.yPos = self.yPos + button.frame.size.height + yPosDiff
                
                self.scrollView.addSubview(button)
                self.joinButtonCount = self.joinButtonCount + 1
                self.scrollView.contentSize.height = 20 + 20 + CGFloat(self.hostButtonCount + self.joinButtonCount)*(button.frame.size.height + yPosDiff) - yPosDiff
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        self.view.addSubview(scrollView)

        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("hello")
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if eventsNavLocal == 1 {
            print("why")
            eventsNavLocal = 0
            tempView = storyboard.instantiateViewControllerWithIdentifier("eventView") as UIViewController
            self.navigationController?.pushViewController(tempView, animated: false)
        }
        self.navigationController?.navigationBarHidden = true
        tabBarController!.tabBar.hidden = false
        print("here1")
        //hostRef.removeAllObservers()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        for btn in scrollView.subviews {
            btn.removeFromSuperview()
        }
        for btn in scrollView2.subviews {
            btn.removeFromSuperview()
        }
        yPos = 20
        yPosConcluded = 20
        hostButtonCount = 0
        hostConcludedButtonCount = 0
        joinButtonCount = 0
        joinConcludedButtonCount = 0
        
        let hostRef = dataBase.childByAppendingPath("users/" + userID + "/hosted events/")
        hostRef.observeEventType(.Value, withBlock: { snapshot in
            //let hostEventsName = snapshot.value as! String
            for name in snapshot.children {
                self.updateEvents(name.key as! String)
            }
            hostRef.removeAllObservers()
        })
    }
    
    func eventAction(sender:Button!) {
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("eventView") as UIViewController
        eventName = sender.string
        eventsNavController.pushViewController(v, animated: true)
    }
    
    func activeAction(sender:Button!) {
        scrollButton.backgroundColor = darkRedColor
        scrollButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        scrollButton2.backgroundColor = UIColor.whiteColor()
        scrollButton2.setTitleColor(darkRedColor, forState: UIControlState.Normal)
        scrollLabelBackground.backgroundColor = darkRedColor
        scrollLabelBackground2.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(scrollLabelBackground2)
        self.view.addSubview(scrollLabelBackground)
        self.view.addSubview(scrollButton)
        self.view.addSubview(scrollButton2)
        scrollView.alpha = 1.0
        scrollView2.alpha = 0.0
    }
    
    func concludedAction(sender:Button!) {
        scrollButton.backgroundColor = UIColor.whiteColor()
        scrollButton.setTitleColor(darkRedColor, forState: UIControlState.Normal)
        scrollButton2.backgroundColor = darkRedColor
        scrollButton2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        scrollLabelBackground.backgroundColor = UIColor.whiteColor()
        scrollLabelBackground2.backgroundColor = darkRedColor
        self.view.addSubview(scrollLabelBackground)
        self.view.addSubview(scrollLabelBackground2)
        self.view.addSubview(scrollButton)
        self.view.addSubview(scrollButton2)
        scrollView.alpha = 0.0
        scrollView2.alpha = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeEvents() {
        for child in scrollView.subviews {
            if let button = child as? Button {
            let tempEventName = button.string
            let endTimeRef = dataBase.childByAppendingPath("events/" + tempEventName + "/end time/")
            endTimeRef.observeEventType(.Value, withBlock: { snapshot in
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
                        let oldRef = dataBase.childByAppendingPath("events/" + tempEventName)
                        oldRef.observeEventType(.Value, withBlock: { snapshot in
                            for child in snapshot.children {
                                let newRef = dataBase.childByAppendingPath("concluded events/" + tempEventName + "/" + child.key)
                                newRef.setValue(child.value)
                            }
                            let localRef = dataBase.childByAppendingPath("locations/" + tempEventName)
                            localRef.removeValue()
                            let activeRef = dataBase.childByAppendingPath("events/" + tempEventName)
                            activeRef.removeValue()
                        })
//                        let userRef = dataBase.childByAppendingPath("users/" + userID)
//                        userRef.observeEventType(.Value, withBlock: { snapshot in
//                            print("hello")
//                            if snapshot.hasChild("hosted events/" + tempEventName) {
//                                print("hello host")
//                                userRef.childByAppendingPath("concluded hosted events/" + tempEventName).setValue(tempEventName)
//                                userRef.childByAppendingPath("hosted events/" + tempEventName).removeValue()
//                            }
//                            if snapshot.hasChild("joined events/" + tempEventName) {
//                                print("hello join")
//                                userRef.childByAppendingPath("concluded joined events/" + tempEventName).setValue(tempEventName)
//                                userRef.childByAppendingPath("joined events/" + tempEventName).removeValue()
//                            }
//                        })
                    }
                }
            })
            }
        }
    }
    
    func updateEvents(hostEventsName: String!) {
        let tempRef = dataBase
        dataBase.observeEventType(.Value, withBlock: { snapshot in
            let button = Button()
            let title = hostEventsName.componentsSeparatedByString("^")[0]
            button.titleLabel!.font = UIFont(name: "Menlo", size: 21*screenSize.width/320) //Chalkboard SE
            button.setTitle(title, forState: UIControlState.Normal)
            button.setTitleColor(self.lightWhiteColor, forState: UIControlState.Normal)
            button.string = hostEventsName
            button.frame = CGRectMake(0, 0, self.scrollView.frame.width*0.9, screenSize.height*0.09)
            button.frame.origin.x = (self.scrollView.frame.width - button.frame.width)*0.5
            button.layer.cornerRadius = 10
            button.addTarget(self, action: "eventAction:", forControlEvents: UIControlEvents.TouchUpInside)
            if snapshot.hasChild("events/" + hostEventsName) {
                if ((self.hostButtonCount + self.joinButtonCount) % 2 == 0) {
                    button.backgroundColor = self.orangyYellowColor//dullPurpleColor//UIColor.whiteColor()
                }
                else if ((self.hostButtonCount + self.joinButtonCount) % 2 == 1) {
                    button.backgroundColor = self.dullRedColor//UIColor.whiteColor()
                }
                else if ((self.hostButtonCount + self.joinButtonCount) % 3 == 2) {
                    button.backgroundColor = self.lightOrangeColor//UIColor.whiteColor()
                }
                let yPosDiff = screenSize.height/60
                button.frame.origin.y = self.yPos
                self.yPos = self.yPos + button.frame.size.height + yPosDiff
                self.hostButtonCount = self.hostButtonCount + 1
                self.scrollView.contentSize.height = 20 + 20 + CGFloat(self.hostButtonCount + self.joinButtonCount)*(button.frame.size.height + yPosDiff) - yPosDiff
                self.scrollView.addSubview(button)
                tempRef.removeAllObservers()
            }
            else if snapshot.hasChild("concluded events/" + hostEventsName) {
                if ((self.hostConcludedButtonCount + self.joinConcludedButtonCount) % 2 == 0) {
                    button.backgroundColor = self.orangyYellowColor//dullPurpleColor//UIColor.whiteColor()
                }
                else if ((self.hostConcludedButtonCount + self.joinConcludedButtonCount) % 2 == 1) {
                    button.backgroundColor = self.dullRedColor//UIColor.whiteColor()
                }
                else if ((self.hostConcludedButtonCount + self.joinConcludedButtonCount) % 3 == 2) {
                    button.backgroundColor = self.lightOrangeColor//UIColor.whiteColor()
                }
                button.frame.origin.y = self.yPosConcluded
                let yPosDiff = screenSize.height/60
                self.yPosConcluded = self.yPos + button.frame.size.height + yPosDiff
                self.hostConcludedButtonCount = self.hostConcludedButtonCount + 1
                self.scrollView2.contentSize.height = 20 + 20 + CGFloat(self.hostConcludedButtonCount + self.joinConcludedButtonCount)*(button.frame.size.height + yPosDiff) - yPosDiff
                self.scrollView2.addSubview(button)
                tempRef.removeAllObservers()
            }
        })
    }

}

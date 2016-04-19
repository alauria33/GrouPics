
import UIKit
import Firebase

class EventsViewController: UIViewController {

    var buttonCount : Int!
    var pastButtonCount : Int!
    
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
        
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
        //scrollView.contentSize = CGSizeMake(scrollView.frame.width, screenSize.height*2)
        buttonCount = 0
        var yPos: CGFloat = 20
        
        let hostRef = dataBase.childByAppendingPath("users/" + userID + "/hosted events/")
        hostRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            let hostEventsName = snapshot.value as! String
            print(hostEventsName)
            if hostEventsName != "null" {
                let button = UIButton()
                button.titleLabel!.font = UIFont(name: "Arial", size: 21*screenSize.width/320)
                button.setTitle(hostEventsName, forState: UIControlState.Normal)
                button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                if (self.buttonCount % 3 == 0) {
                    button.backgroundColor = darkOrangeColor//UIColor.whiteColor()
                }
                else if (self.buttonCount % 3 == 1) {
                    button.backgroundColor = darkRedColor//UIColor.whiteColor()
                }
                else if (self.buttonCount % 3 == 2) {
                    button.backgroundColor = lightOrangeColor//UIColor.whiteColor()
                }
                
                button.frame = CGRectMake(0, 0, self.scrollView.frame.width*0.8, self.scrollView.frame.height*0.15)
                button.frame.origin.x = (self.scrollView.frame.width - button.frame.width)*0.5
                button.frame.origin.y = yPos
                button.layer.cornerRadius = 10
                
                button.addTarget(self, action: "eventAction:", forControlEvents: UIControlEvents.TouchUpInside)
                yPos = yPos + button.frame.size.height + screenSize.height/60
                
                self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width, CGFloat(self.buttonCount)*self.scrollView.frame.height*0.15 + screenSize.height/60*CGFloat(self.buttonCount) + 90)
                
                self.scrollView.addSubview(button)
                self.buttonCount = self.buttonCount + 1
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        let joinRef = dataBase.childByAppendingPath("users/" + userID + "/joined events/")
        joinRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            let hostEventsName = snapshot.value as! String
            print(hostEventsName)
            if hostEventsName != "null" {
                let button = UIButton()
                button.titleLabel!.font = UIFont(name: "Arial", size: 21*screenSize.width/320)
                button.setTitle(hostEventsName, forState: UIControlState.Normal)
                button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                if (self.buttonCount % 3 == 0) {
                    button.backgroundColor = darkOrangeColor//UIColor.whiteColor()
                }
                else if (self.buttonCount % 3 == 1) {
                    button.backgroundColor = darkRedColor//UIColor.whiteColor()
                }
                else if (self.buttonCount % 3 == 2) {
                    button.backgroundColor = lightOrangeColor//UIColor.whiteColor()
                }
                
                button.frame = CGRectMake(0, 0, self.scrollView.frame.width*0.8, self.scrollView.frame.height*0.15)
                button.frame.origin.x = (self.scrollView.frame.width - button.frame.width)*0.5
                button.frame.origin.y = yPos
                button.layer.cornerRadius = 10
                
                button.addTarget(self, action: "eventAction:", forControlEvents: UIControlEvents.TouchUpInside)
                yPos = yPos + button.frame.size.height + screenSize.height/60
                
                self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width, CGFloat(self.buttonCount)*self.scrollView.frame.height*0.15 + screenSize.height/60*CGFloat(self.buttonCount) + 90)
                
                self.scrollView.addSubview(button)
                self.buttonCount = self.buttonCount + 1
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        self.view.addSubview(scrollView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if eventsNavLocal == 1 {
            eventsNavLocal = 0
            tempView = storyboard.instantiateViewControllerWithIdentifier("eventView") as UIViewController
            self.navigationController?.pushViewController(tempView, animated: false)
        }
        self.navigationController?.navigationBarHidden = true
        tabBarController!.tabBar.hidden = false
    }
    
    func eventAction(sender:UIButton!) {
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("eventView") as UIViewController
        eventName = (sender.titleLabel?.text)!
        eventsNavController.pushViewController(v, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

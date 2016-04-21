
import UIKit
import Firebase

class EventsViewController: UIViewController {

    var buttonCount : Int!
    var pastButtonCount : Int!
    
    var scrollView: UIScrollView!
    var scrollView2: UIScrollView!
    
    let scrollButton = UIButton()
    let scrollButton2 = UIButton()
    let scrollLabelBackground = UILabel()
    let scrollLabelBackground2 = UILabel()
    
    let darkRedColor = UIColor(red: 109/255.0, green: 32/255.0, blue: 24/255.0, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
        
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
        
        buttonCount = 0
        var yPos: CGFloat = 20
        
        let hostRef = dataBase.childByAppendingPath("users/" + userID + "/hosted events/")
        hostRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            let hostEventsName = snapshot.value as! String
            if hostEventsName != "null" {
                let button = Button()
                let title = hostEventsName.componentsSeparatedByString("^")[0]
                button.titleLabel!.font = UIFont(name: "Menlo", size: 21*screenSize.width/320) //Chalkboard SE
                button.setTitle(title, forState: UIControlState.Normal)
                button.setTitleColor(lightWhiteColor, forState: UIControlState.Normal)
                button.string = hostEventsName
                if (self.buttonCount % 2 == 0) {
                    button.backgroundColor = orangyYellowColor//dullPurpleColor//UIColor.whiteColor()
                }
                else if (self.buttonCount % 2 == 1) {
                    button.backgroundColor = dullRedColor//UIColor.whiteColor()
                }
                else if (self.buttonCount % 3 == 2) {
                    button.backgroundColor = lightOrangeColor//UIColor.whiteColor()
                }
                button.frame = CGRectMake(0, 0, self.scrollView.frame.width*0.9, screenSize.height*0.09)
                button.frame.origin.x = (self.scrollView.frame.width - button.frame.width)*0.5
                button.frame.origin.y = yPos
                button.layer.cornerRadius = 10
                
                button.addTarget(self, action: "eventAction:", forControlEvents: UIControlEvents.TouchUpInside)
                let yPosDiff = screenSize.height/60
                yPos = yPos + button.frame.size.height + yPosDiff
                
                self.scrollView.addSubview(button)
                self.buttonCount = self.buttonCount + 1
                self.scrollView.contentSize.height = 20 + 20 + CGFloat(self.buttonCount)*(button.frame.size.height + yPosDiff) - yPosDiff
            }
        })
        
        let joinRef = dataBase.childByAppendingPath("users/" + userID + "/joined events/")
        joinRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            let hostEventsName = snapshot.value as! String
            if hostEventsName != "null" {
                let button = Button()
                let title = hostEventsName.componentsSeparatedByString("^")[0]
                button.titleLabel!.font = UIFont(name: "Menlo", size: 21*screenSize.width/320) //Chalkboard SE
                button.setTitle(title, forState: UIControlState.Normal)
                button.setTitleColor(lightWhiteColor, forState: UIControlState.Normal)
                button.string = hostEventsName
                if (self.buttonCount % 2 == 0) {
                    button.backgroundColor = orangyYellowColor//dullPurpleColor//UIColor.whiteColor()
                }
                else if (self.buttonCount % 2 == 1) {
                    button.backgroundColor = dullRedColor//UIColor.whiteColor()
                }
                else if (self.buttonCount % 3 == 2) {
                    button.backgroundColor = lightOrangeColor//UIColor.whiteColor()
                }
                button.frame = CGRectMake(0, 0, self.scrollView.frame.width*0.9, screenSize.height*0.09)
                button.frame.origin.x = (self.scrollView.frame.width - button.frame.width)*0.5
                button.frame.origin.y = yPos
                button.layer.cornerRadius = 10
                
                button.addTarget(self, action: "eventAction:", forControlEvents: UIControlEvents.TouchUpInside)
                let yPosDiff = screenSize.height/60
                yPos = yPos + button.frame.size.height + yPosDiff
                
                self.scrollView.addSubview(button)
                self.buttonCount = self.buttonCount + 1
                self.scrollView.contentSize.height = 20 + 20 + CGFloat(self.buttonCount)*(button.frame.size.height + yPosDiff) - yPosDiff
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        self.view.addSubview(scrollView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if eventsNavLocal == 1 {
            print("why")
            eventsNavLocal = 0
            tempView = storyboard.instantiateViewControllerWithIdentifier("eventView") as UIViewController
            self.navigationController?.pushViewController(tempView, animated: false)
        }
        self.navigationController?.navigationBarHidden = true
        tabBarController!.tabBar.hidden = false
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


}

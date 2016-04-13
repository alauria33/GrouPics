
import UIKit
import Firebase

class EventsViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if eventsNavLocal == 1 {
            eventsNavLocal = 0
            tempView = storyboard.instantiateViewControllerWithIdentifier("eventView") as UIViewController
            self.navigationController?.pushViewController(tempView, animated: false)
        }
        self.navigationController?.navigationBarHidden = true
        let userRef = dataBase.childByAppendingPath("users/")
        userRef.observeEventType(.Value, withBlock: { snapshot in
            if snapshot.hasChild(userID) {
                print("found user id")
                let userIDRef = dataBase.childByAppendingPath("users/" + userID)
                userIDRef.observeEventType(.Value, withBlock: { snapshot in
                    if snapshot.hasChild("hosted events") {
                        print("found hosted events")
                        eventName = snapshot.value.objectForKey("hosted events") as! String
                        if eventName != "" {
                            let event   = UIButton(type: UIButtonType.System) as UIButton
                            event.setTitle(eventName, forState: UIControlState.Normal)
                            let circle : UIImage? = UIImage(named:"circle")
                            event.titleLabel!.font = UIFont(name: "ChalkboardSE-Bold", size: 21*screenSize.width/320)
                            event.frame = CGRectMake(0, 0, screenSize.width * 0.7, screenSize.height * 0.09)
                            event.frame.origin.x = (screenSize.width - event.frame.size.width)/2
                            event.frame.origin.y = (screenSize.height - event.frame.size.height)*0.4
                            let blueColor = UIColor(red: 136/255, green: 175/255, blue: 239/255, alpha: 1.0)
                            event.setTitleColor(blueColor, forState: UIControlState.Normal)
                            event.setBackgroundImage(circle, forState: UIControlState.Normal)
                            event.addTarget(self, action: #selector(self.eventAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                            self.view.addSubview(event)
                        }
                    }
                    }, withCancelBlock: { error in
                            print(error.description)
                })
            }
        })
    }
    
    func eventAction(sender:UIButton!) {
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("eventView") as UIViewController
        eventsNavController.pushViewController(v, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

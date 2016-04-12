
import UIKit
import Firebase

class EventsViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        let next   = UIButton(type: UIButtonType.System) as UIButton
        if picked == 1 {
            let userRef = dataBase.childByAppendingPath("users/" + userID)
            userRef.observeEventType(.Value, withBlock: { snapshot in
                eventName = snapshot.value.objectForKey("hosted events") as! String
                next.setTitle(eventName, forState: UIControlState.Normal)
                }, withCancelBlock: { error in
                    print(error.description)
            })
        }
        eventName = "Test1"
        next.setTitle(eventName, forState: UIControlState.Normal)
        let circle : UIImage? = UIImage(named:"circle")
        next.titleLabel!.font = UIFont(name: "ChalkboardSE-Bold", size: 21*screenSize.width/320)
        next.frame = CGRectMake(0, 0, screenSize.width * 0.7, screenSize.height * 0.09)
        next.frame.origin.x = (screenSize.width - next.frame.size.width)/2
        next.frame.origin.y = (screenSize.height - next.frame.size.height)*0.4
        let blueColor = UIColor(red: 136/255, green: 175/255, blue: 239/255, alpha: 1.0)
        next.setTitleColor(blueColor, forState: UIControlState.Normal)
        next.setBackgroundImage(circle, forState: UIControlState.Normal)
        next.addTarget(self, action: #selector(eventAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(next)

    }
    
    func eventAction(sender:UIButton!) {
//        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("eventView") as UIViewController
//        self.navigationController!.pushViewController(v, animated: true)
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("eventView") as UIViewController
        eventsNavController.pushViewController(v, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

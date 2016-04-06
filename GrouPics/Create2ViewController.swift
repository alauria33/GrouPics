//
//  Create2ViewController.swift
//  GrouPics
//
//  Created by Andrew on 3/28/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

var dateInput : String = String()

class Create2ViewController: UIViewController {

    var date: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        next.addTarget(self, action: #selector(Create2ViewController.nextAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        date = UIDatePicker()
        date.frame = CGRectMake(0, 0, screenSize.width * 0.9, screenSize.height * 0.4)
        date.frame.origin.x = (screenSize.width - date.frame.size.width)*0.5
        date.frame.origin.y = (screenSize.height - date.frame.size.height)*0.5
        self.view.addSubview(date)
        self.view.addSubview(next)
        
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    
    func nextAction(sender:UIButton!) {
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("createView3") as UIViewController
        createNavController.pushViewController(v, animated: true)
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        var d: NSDate = date.date
//        let et = dateFormatter.stringFromDate(date.date)
//        let tempRef = ref.childByAppendingPath("/endtime")
//        tempRef.setValue(et)
        dateInput = dateFormatter.stringFromDate(date.date)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

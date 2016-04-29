//
//  SetTimeViewController.swift
//  GrouPics
//
//  Created by Thomas Weng on 4/28/16.
//  Copyright © 2016 Andrew. All rights reserved.
//
import UIKit
class EditTimeViewController: UIViewController {
    var date: UIDatePicker!
    var newDate : String = String()
    let eventRef = dataBase.childByAppendingPath("events/" + eventName)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor() //veryDullRedColor
        titleLabel.text = "Change event end time?"
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Menlo-Bold", size: 25*screenSize.width/375)
        titleLabel.frame = CGRectMake(0, 0, screenSize.width, screenSize.height * 0.15)
        titleLabel.frame.origin.x = (screenSize.width - titleLabel.frame.size.width)/2
        titleLabel.frame.origin.y = (screenSize.height - titleLabel.frame.size.height)*0.1
        titleLabel.alpha = 1.0
        self.view.addSubview(titleLabel)
        
        date = UIDatePicker()
        date.frame = CGRectMake(0, 0, screenSize.width * 0.9, screenSize.height * 0.4)
        date.frame.origin.x = (screenSize.width - date.frame.size.width)*0.5
        date.frame.origin.y = (screenSize.height - date.frame.size.height)*0.5
        date.tintColor = UIColor.whiteColor()
        self.view.addSubview(date)
        
        let save = UIButton()
        save.titleLabel!.font = UIFont(name: "Menlo", size: 16*screenSize.width/320)
        save.setTitle("Save End Time", forState: UIControlState.Normal)
        save.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        save.backgroundColor = UIColor(red: 135/255, green: 20/255, blue: 0/255, alpha: 1.0)
        save.frame = CGRectMake(0, 0, screenSize.width * 0.5, screenSize.height * 0.1)
        save.frame.origin.x = screenSize.width - save.frame.size.width
        save.frame.origin.y = date.frame.origin.y + date.frame.height + 60
        save.alpha = 1.0
        
        save.addTarget(self, action: "saveAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(save)
        
        
        
    }
    
    func saveAction(sender:UIButton!) {
        eventsNavController.popViewControllerAnimated(true)
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        var d: NSDate = date.date
        //        let et = dateFormatter.stringFromDate(date.date)
        //        let tempRef = ref.childByAppendingPath("/endtime")
        //        tempRef.setValue(et)
        newDate = dateFormatter.stringFromDate(date.date)
        var tempRef = eventRef.childByAppendingPath("end time/")
        tempRef.setValue(newDate)
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
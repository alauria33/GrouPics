//
//  EventsNavigationController.swift
//  GrouPics
//
//  Created by Andrew on 3/28/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

var tempImg : UIImage = UIImage()
var eventsNavController : UINavigationController = UINavigationController()

class EventsNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        eventsNavController = self as UINavigationController
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {

        
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

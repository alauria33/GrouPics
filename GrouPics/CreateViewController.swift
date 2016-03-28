//
//  CreateViewController.swift
//  GrouPics
//
//  Created by Andrew on 3/27/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {

    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let circle : UIImage? = UIImage(named:"circle")
    @IBOutlet weak var create: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var descrip: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let create   = UIButton(type: UIButtonType.System) as UIButton
        create.titleLabel!.font = UIFont(name: "ChalkboardSE-Regular", size: 20)
        create.frame = CGRectMake(0, 0, screenSize.width * 0.43, screenSize.height * 0.14)
        create.frame.origin.x = (screenSize.width - create.frame.size.width)/2
        create.frame.origin.y = (screenSize.height - create.frame.size.height)*0.81
        create.setTitle("Create Event", forState: UIControlState.Normal)
        create.setBackgroundImage(circle, forState: UIControlState.Normal)
        create.addTarget(self, action: #selector(CreateViewController.createAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(create)
        descrip.frame.size.height = screenSize.height/5
        name.frame.origin.y = screenSize.height*0.25
        descrip.frame.origin.y = name.frame.origin.y + 10
        password.frame.origin.y = descrip.frame.origin.y + 10
    }
    
    func createAction(sender:UIButton!) {
        let n = name.text!
        let d = descrip.text!
        let p = password.text!
        print()
        print("name: " + n)
        print("description: " + d)
        print("password: " + p)
        print()
        //let ev = (self.storyboard?.instantiateViewControllerWithIdentifier("EventViewController"))! as UIViewController
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var ev: UIViewController = storyboard.instantiateViewControllerWithIdentifier("eventView") as UIViewController
        self.presentViewController(ev, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

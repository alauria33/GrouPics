//
//  CreateViewController.swift
//  GrouPics
//
//  Created by Andrew on 3/27/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit
import Firebase

var tempString: String = String()

class CreateViewController: UIViewController {

    let circle : UIImage? = UIImage(named:"circle")
    @IBOutlet weak var next: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var descrip: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let next   = UIButton(type: UIButtonType.System) as UIButton
        next.titleLabel!.font = UIFont(name: "ChalkboardSE-Bold", size: 21*screenSize.width/320)
        next.frame = CGRectMake(0, 0, screenSize.width * 0.3, screenSize.height * 0.09)
        next.frame.origin.x = (screenSize.width - next.frame.size.width)/2
        next.frame.origin.y = (screenSize.height - next.frame.size.height)*0.82
        next.setTitle("Next", forState: UIControlState.Normal)
        let blueColor = UIColor(red: 136/255, green: 175/255, blue: 239/255, alpha: 1.0)
        next.setTitleColor(blueColor, forState: UIControlState.Normal)
        next.setBackgroundImage(circle, forState: UIControlState.Normal)
        next.addTarget(self, action: #selector(CreateViewController.nextAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let borderColor = UIColor(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0)
        descrip.layer.borderColor = borderColor.CGColor;
        descrip.layer.borderWidth = 0.8;
        descrip.layer.cornerRadius = 5.0;
        self.view.addSubview(next)
        descrip.frame.size.height = screenSize.height/5
        name.frame.origin.y = screenSize.height*0.25
        descrip.frame.origin.y = name.frame.origin.y + 10
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func nextAction(sender:UIButton!) {
        let n = name.text!
        let d = descrip.text!
        var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var v: UIViewController = storyboard.instantiateViewControllerWithIdentifier("createView2") as UIViewController
        createNavController.pushViewController(v, animated: true)
        ref = Firebase(url:"https://groupics333.firebaseio.com/")
        ref = ref.childByAppendingPath("events/" + n)
        var tempRef = ref.childByAppendingPath("/name")
        tempRef.setValue(n)
        tempRef = ref.childByAppendingPath("/description")
        tempRef.setValue(d)
        tempString = n
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

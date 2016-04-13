//
//  PictureViewController.swift
//  GrouPics
//
//  Created by Andrew on 4/10/16.
//  Copyright © 2016 Andrew. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController {

    var hidden: Bool = true
    
    @IBOutlet weak var img: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        img.image = viewingPicture
        let screenButton   = UIButton(type: UIButtonType.System) as UIButton
        screenButton.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        screenButton.frame.origin.x = (screenSize.width - screenButton.frame.size.width)/2
        screenButton.frame.origin.y = (screenSize.height - screenButton.frame.size.height)/2
        screenButton.addTarget(self, action: "screenButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(screenButton)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        tabBarController!.tabBar.hidden = true
    }
    

    func screenButtonAction(sender:UIButton!) {
        if self.hidden {
            self.navigationController?.navigationBarHidden = false
            //tabBarController!.tabBar.hidden = false
            hidden = false
        }
        else {
            self.navigationController?.navigationBarHidden = true
            //tabBarController!.tabBar.hidden = true
            hidden = true
        }
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

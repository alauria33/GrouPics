import UIKit

class AlbumsViewController: UIViewController {
    
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ScrollView.frame = CGRectMake(screenSize.width/2, screenSize.height/2.5, screenSize.width, screenSize.height*0.85)
        
        ScrollView.contentSize.height = 1000

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //hello there --- committed yooooooooo

}

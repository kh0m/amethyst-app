//
//  WebViewController.swift
//  AmethystApp
//
//  Created by Hom, Kenneth on 11/16/15.
//  Copyright © 2015 Hom, Kenneth. All rights reserved.
//

import UIKit
import CoreData

class WebViewController: UIViewController {
    
    var course: NSManagedObject?
    @IBOutlet weak var courseView: UIWebView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var link = course!.valueForKey("link") as! NSString
        link = link.stringByReplacingOccurrencesOfString("\\", withString: "/")
        let url = NSURL(string: link as String)
        let requestObject = NSURLRequest(URL: url!)
        courseView.loadRequest(requestObject)
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

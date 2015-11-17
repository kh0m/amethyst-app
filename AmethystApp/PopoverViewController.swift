//
//  PopoverViewController.swift
//  AmethystApp
//
//  Created by Hom, Kenneth on 11/16/15.
//  Copyright © 2015 Hom, Kenneth. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
    
    var labelText: String?
    @IBOutlet weak var clientNumberLabel: UILabel!

    @IBAction func dismissPopover(sender: AnyObject) {
        self.dismissPopover(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        clientNumberLabel.text = labelText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.Popover
    }
    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }

}

//
//  CoursesViewController.swift
//  AmethystApp
//
//  Created by Hom, Kenneth on 10/26/15.
//  Copyright © 2015 Hom, Kenneth. All rights reserved.
//

import UIKit
import CoreData

class CoursesViewController: UIViewController, UITableViewDataSource {
    
    var courses = [NSManagedObject]()
    
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Courses"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addCourse(sender: AnyObject) {
        let alert = UIAlertController(title: "New Course", message: "Add a Course", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action: UIAlertAction) -> Void in
                let textField = alert.textFields!.first
                self.saveCourse(textField!.text!)
                self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in }
        
        alert.addTextFieldWithConfigurationHandler { (textfield: UITextField) -> Void in }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveCourse(name: String){
        // 1: Get managed object context
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // 2: Get the entity and create new managed object with it
        let entity = NSEntityDescription.entityForName("Course", inManagedObjectContext: managedContext)
        let course = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        // 3: Get the attribute and set it to the managed object
        course.setValue(name, forKey: "title")
        
        // 4: Commit the changes to course by calling with a try in a do
        do {
            try managedContext.save()
            
            // 5: Insert into the array so the table reloads with it.
            courses.append(course)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let course = courses[indexPath.row]
        cell!.textLabel!.text = course.valueForKey("title") as? String
        
        
        return cell!
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

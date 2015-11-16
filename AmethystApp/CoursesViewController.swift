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
    
    var clientCourses = [NSManagedObject]()
    var client: NSManagedObject?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Courses"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        print(client)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let courses = client!.valueForKey("courses")
        for course in courses as! NSMutableSet{
            clientCourses.append(course as! NSManagedObject)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
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
        
        let course = NSEntityDescription.insertNewObjectForEntityForName("Course", inManagedObjectContext: managedContext)
        
        // 3: Get the attribute and set it to the managed object
        course.setValue(name, forKey: "title")
        course.setValue(client, forKey: "client")

        // 4: Commit the changes to course by calling with a try in a do
        do {
            try managedContext.save()
            
            // 5: Insert into the array so the table reloads with it.
            clientCourses.append(course)
            
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientCourses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let course = clientCourses[indexPath.row]
        cell.textLabel!.text = course.valueForKey("title") as? String
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("toWebView", sender: clientCourses[indexPath.row])
    }
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toWebView" {
            if let destinationVC = segue.destinationViewController as? WebViewController {
                destinationVC.course = sender as? NSManagedObject
            }
        }
    }

}

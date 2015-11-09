//
//  ViewController.swift
//  AmethystApp
//
//  Created by Hom, Kenneth on 9/30/15.
//  Copyright © 2015 Hom, Kenneth. All rights reserved.
//

import UIKit
import CoreData

// Add UITableViewDataSource and UITableViewDelegate to class declaration
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var clients = [NSManagedObject]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Clients"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Client")
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            clients = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let client = clients[indexPath.row]
        
        cell!.textLabel!.text = client.valueForKey("name") as? String
        if let courses = client.valueForKey("courses"){
            cell!.detailTextLabel?.text = "\(courses.count) Courses"
        }
        
        return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addClient(sender: AnyObject) {
        let alert = UIAlertController(title: "New Client", message: "Add a Client", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action: UIAlertAction) -> Void in
                let textField = alert.textFields!.first
                self.saveClient(textField!.text!)
                self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in }
        
        alert.addTextFieldWithConfigurationHandler { (textfield: UITextField) -> Void in }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveClient(name: String) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity = NSEntityDescription.entityForName("Client", inManagedObjectContext: managedContext)
        let client = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        //3
        client.setValue(name, forKey: "name")
        
        //4
        do {
            try managedContext.save()
        //5
            clients.append(client)
        }  catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("toCourses", sender: clients[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toCourses" {
            if let destinationVC = segue.destinationViewController as? CoursesViewController {
                destinationVC.client = sender as? NSManagedObject
            }
        }
    }
    
}


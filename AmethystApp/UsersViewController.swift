//
//  ViewController.swift
//  AmethystApp
//
//  Created by Hom, Kenneth on 9/30/15.
//  Copyright © 2015 Hom, Kenneth. All rights reserved.
//

import UIKit
import CoreData
import Lock
import SimpleKeychain

// Add UITableViewDataSource and UITableViewDelegate to class declaration
class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    var users = [NSManagedObject]()
    @IBOutlet weak var tableView: UITableView!
    lazy var refresher = UIRefreshControl()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view, typically from a nib.
        title = "Users"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        refresher.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refresher)
    }
    
    func refresh(sender: AnyObject){
        tableView.reloadData()
        refresher.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        //3
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            users = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let user = users[indexPath.row] as! User
        
        cell.textLabel!.text = user.email
//        let courses = user.courses
//        cell.detailTextLabel?.text = String(courses!.count)
        
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Methods
    
    @IBAction func showDetails(sender: UIBarButtonItem) {}
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
        
//    func saveClient(name: String) {
//        //1
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let managedContext = appDelegate.managedObjectContext
//        
//        //2
//        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedContext)
//        let client = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
//        
//        //3
//        client.setValue(name, forKey: "name")
//        
//        //4
//        do {
//            try managedContext.save()
//        //5
//            clients.append(client)
//        }  catch let error as NSError {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//        
//    }
    
    func preloadData () {
        // Remove all the menu items before preloading
        removeData()
        
        
        ////////////////////////
        
//                var error:NSError?
//                let remoteURL = NSURL(string: "http://testing.pinsonault.com/ken/eModuleLinks.csv")!
//                if let items = parseCSV(remoteURL, encoding: NSUTF8StringEncoding, error: &error) {
//                    // Preload the items
//                    let managedObjectContext = self.managedObjectContext
//        
//                    for item in items {
//                        //
//        
//                        let course = NSEntityDescription.insertNewObjectForEntityForName("Course", inManagedObjectContext: managedObjectContext) as! Course
//                        course.title = item.title
//                        course.link = item.link
//                        course.topic = item.topic
//        
//                        let fetchRequest = NSFetchRequest(entityName: "Client")
//                        let predicate = NSPredicate(format: "name == %@", item.client)
//                        fetchRequest.predicate = predicate
//        
//                        if(managedObjectContext.countForFetchRequest(fetchRequest, error: nil) == 0){
//                            let client = NSEntityDescription.insertNewObjectForEntityForName("Client", inManagedObjectContext: managedObjectContext) as! Client
//                            client.name = item.client
//                            client.courses?.addObject(course)
//                        } else {
//                            do {
//                                let results = try managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
//                                let client = results.first
//        
//                                course.setValue(client, forKey: "client")
//        
//                            } catch {
//                                print("fetching error.")
//                            }
//                        }
//                        //
//        
//                        do {
//                            try managedObjectContext.save()
//                        } catch let error as NSError {
//                            print("insert error: \(error.localizedDescription)")
//                        }
//        
//                    }
//                }
    }
    
    func removeData() {
        // Remove the existing items
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "User")
        do {
            let users = try managedObjectContext.executeFetchRequest(fetchRequest) as! [User]
            for user in users {
                managedObjectContext.deleteObject(user)
            }
        }
        catch let error as NSError{
            print("error: \(error.localizedDescription)")
        }
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("toCourses", sender: users[indexPath.row])
    }
    
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toCourses") {
            if let destinationVC = segue.destinationViewController as? CoursesViewController {
//                destinationVC.user = sender as? NSManagedObject
            }
        } else if (segue.identifier == "toDetailsPopover") {
            if let destinationVC = segue.destinationViewController as? PopoverViewController {
                destinationVC.modalPresentationStyle = UIModalPresentationStyle.Popover
                destinationVC.popoverPresentationController!.delegate = self
                destinationVC.labelText = "Total number of users: \(users.count)"
            }
        }
    }
    
}


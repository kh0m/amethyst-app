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
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    var clients = [NSManagedObject]()
    @IBOutlet weak var tableView: UITableView!
    lazy var refresher = UIRefreshControl()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Clients"
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
        let fetchRequest = NSFetchRequest(entityName: "Client")
        
        //3
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            clients = results as! [NSManagedObject]
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
        return clients.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let client = clients[indexPath.row] as! Client
        
        cell.textLabel!.text = client.name
        let courses = client.courses
        cell.detailTextLabel?.text = String(courses!.count)
        
        
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
    
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toCourses") {
            if let destinationVC = segue.destinationViewController as? CoursesViewController {
                destinationVC.client = sender as? NSManagedObject
            }
        } else if (segue.identifier == "toDetailsPopover") {
            if let destinationVC = segue.destinationViewController as? PopoverViewController {
                destinationVC.modalPresentationStyle = UIModalPresentationStyle.Popover
                destinationVC.popoverPresentationController!.delegate = self
                destinationVC.labelText = "Total number of clients: \(clients.count)"
            }
        }
    }
    
}


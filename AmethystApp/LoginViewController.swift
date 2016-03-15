//
//  LoginViewController.swift
//  AmethystApp
//
//  Created by Hom, Kenneth on 3/14/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//

import UIKit
import CoreData
import Lock
import SimpleKeychain

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.requestLogin()
        
        // MARK: Auth0
        // check for non-expired token
        let keychain = A0SimpleKeychain(service: "Auth0")
        
        if let token = keychain.stringForKey("refresh_token") {
            let client = A0Lock.sharedLock().apiClient()
            client.fetchNewIdTokenWithRefreshToken(token,
                parameters: nil,
                
                success: { token in
                    keychain.setString(token.idToken, forKey: "id_token")
                    // Just got a new id_token!
                    
                    // Get user info from profile
                    let keychain = A0SimpleKeychain(service: "Auth0")
                    if let data = keychain.dataForKey("profile"), let profile = NSKeyedUnarchiver.unarchiveObjectWithData(data) {
                        print("\(profile.identities[0].userId)")
                        loadUserFrom(profile.identities[0].userId)
                    }
                },
                
                failure: { error in
                    keychain.clearAll() // Cleaning stored values since they are no longer valid
                    
                    // id_token is no longer valid. ask the user to login again!
                    self.requestLogin()
                }
            )
        } else {
            self.requestLogin()
        }
        


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


func loadUserFrom(userId: String) {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let requestURL = NSURL(string: "http://localhost:3000/user_from/\(userId)")!
    let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(urlRequest) {
        (data, response, error) -> Void in
        
        let httpResponse = response as! NSHTTPURLResponse
        let statusCode = httpResponse.statusCode
        
        if (statusCode == 200) {
            do {
                print("get data")
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                
                    print("json: \(json)")
                    // save users
                    let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext) as! User
                    user.email = json["email"] as? String
                    user.role = json["role"] as? String

            } catch {
                print("Error with Json: \(error)")

            }
            
        }
    }
    
    task.resume()

}

extension UIViewController {
    func requestLogin() {
        let controller = A0Lock.sharedLock().newLockViewController()
        controller.onAuthenticationBlock = { (profile, token) in
            
            guard let profile = profile, let token = token else {
                return // it's a sign up
            }
            
            // save tokens and profile
            let keychain = A0SimpleKeychain(service: "Auth0")
            keychain.setString(token.idToken, forKey: "id_token")
            
            if let refreshToken = token.refreshToken {
                keychain.setString(refreshToken, forKey: "refresh_token")
            }
            
            keychain.setData(NSKeyedArchiver.archivedDataWithRootObject(profile), forKey: "profile")
            
            // dismiss lock
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        // customize theme
        let DRGTheme = A0Theme()
        
        DRGTheme.registerImageWithName("DRG_icon", bundle: NSBundle.mainBundle(), forKey: "A0ThemeIconImageName")
        DRGTheme.registerColor(UIColor.clearColor(), forKey:"A0ThemeIconBackgroundColor")
        
        DRGTheme.registerColor(self.view.tintColor, forKey:"A0ThemePrimaryButtonNormalColor")
        DRGTheme.registerColor(UIColor.lightGrayColor(), forKey:"A0ThemePrimaryButtonHighlightedColor")
        
        A0Theme.sharedInstance().registerTheme(DRGTheme)
        
        self.presentViewController(controller, animated: true, completion: nil)
    }

}
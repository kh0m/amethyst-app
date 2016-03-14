//
//  LoginViewController.swift
//  AmethystApp
//
//  Created by Hom, Kenneth on 3/14/16.
//  Copyright © 2016 Hom, Kenneth. All rights reserved.
//

import UIKit
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
                    // self.preloadData()
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
        
        DRGTheme.registerImageWithName("DRG_logo", bundle: NSBundle.mainBundle(), forKey: "A0ThemeIconImageName")
        DRGTheme.registerColor(UIColor.clearColor(), forKey:"A0ThemeIconBackgroundColor")
        
        DRGTheme.registerColor(self.view.tintColor, forKey:"A0ThemePrimaryButtonNormalColor")
        DRGTheme.registerColor(UIColor.lightGrayColor(), forKey:"A0ThemePrimaryButtonHighlightedColor")
        
        A0Theme.sharedInstance().registerTheme(DRGTheme)
        
        self.presentViewController(controller, animated: true, completion: nil)
    }

}
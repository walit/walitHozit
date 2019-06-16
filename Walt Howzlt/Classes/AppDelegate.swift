//
//  AppDelegate.swift
//  Walt Howzlt
//
//  Created by Arjun on 1/5/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var loginHandler = LoginHandler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //IQKeyboardManager.shared.enable = true
    
        //IQKeyboardManager.shared.disabledToolbarClasses = [ChatViewController.self]
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
         print("forgouned")
       
         self.checkLoagin()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("active")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
     func resetDefaults() {
       
        let rootViewController = self.window!.rootViewController as! UINavigationController
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
        rootViewController.pushViewController(profileViewController, animated: true)
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
   
    func checkLoagin ()
    {
        
        let keychain = KeychainSwift()
        let deviceId = keychain.get("device_uuid")
        
        self.loginHandler.SignInHandler(deviceID: deviceId ?? "", completion: {isValid,_,_ in
            if isValid == true{
                let rootViewController = self.window!.rootViewController as! UINavigationController
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                rootViewController.pushViewController(profileViewController, animated: true)
                
                
            }else{
                //self.showAlert(title: "Error", message: "Please login in main app.")
                let rootViewController = self.window!.rootViewController as! UINavigationController
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
                rootViewController.pushViewController(profileViewController, animated: true)
            }
        })
        
        
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}


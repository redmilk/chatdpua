//
//  AppDelegate.swift
//  chatdpua
//
//  Created by Artem on 1/24/17.
//  Copyright © 2017 ApiqA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

var refToDataBaseWithUsers: FIRDatabaseReference!
var refToStorageWithUsers: FIRStorageReference!

var refToStorageWithPosts: FIRStorageReference!
var refToDataBaseWithPosts: FIRDatabaseReference!

var ref: FIRDatabaseReference!
var storage: FIRStorageReference!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var container: UIView!

    /// DidFinishLaunhingWithOptions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ///firebase
        FIRApp.configure()
        storage = FIRStorage.storage().reference(forURL: "gs://chatdpua.appspot.com")
        refToStorageWithUsers = storage.child("users")
        refToDataBaseWithUsers = FIRDatabase.database().reference().child("users")
        refToStorageWithPosts = storage.child("posts")
        refToDataBaseWithPosts = FIRDatabase.database().reference().child("posts")
        ref = FIRDatabase.database().reference()
        
        //navigation bar
        UINavigationBar.appearance().barTintColor = UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        //UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }

    class func instance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func showActivityIndicator() {
        if let window = window {
            self.container = UIView()
            self.container.frame = window.frame
            self.container.center = window.center
            self.container.backgroundColor = UIColor(white: 0, alpha: 0.8)
            
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.center = CGPoint(x: self.container.frame.size.width/2, y: self.container.frame.size.height/2)
            
            self.container.addSubview(self.activityIndicator)
            self.window?.addSubview(self.container)
            
            self.activityIndicator.startAnimating()
        }
    }
    
    func dismissActivityIndicator() {
        if let _ = self.window {
            self.container.removeFromSuperview()
        }
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


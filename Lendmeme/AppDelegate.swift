//
//  AppDelegate.swift
//  meme 1.0
//
//  Created by sudo on 12/6/17.
//  Copyright © 2017 sudo. All rights reserved.
//

import UIKit
import CoreData
import Firebase
//import GoogleMobileAds
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
//    var borrowInfo = [BorrowInfo]()
  
    let dataController = DataController(modelName: "BorrowTime")
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        // Override point for customization after application launch.
        dataController.load()
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
        let navigationController = window?.rootViewController as! UINavigationController
        let BorrowTableViewStarter = navigationController.topViewController as! BorrowTableViewController
        BorrowTableViewStarter.dataController = dataController
        
        // MARK: - Notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (accepted, error) in
            if !accepted {
                print("Notifications access denied")
            }
        }
//        let action = UNNotificationAction(identifier: "myCategory", title: "Remind me later", options: [])
//        let category = UNNotificationCategory(identifier: "myCategory", actions: [action], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [])
//        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        
        return true
    }
    
    func scheduleNotification(at date: Date, name: String) {
        
         let center = UNUserNotificationCenter.current()
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "🙌 Just a reminder"
        content.body = "Your \(name) has been out there for a while. Remind them that you want it back."
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        center.add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveViewContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveViewContext()
    }
    func saveViewContext() {
        try? dataController.viewContext.save()
    }


}


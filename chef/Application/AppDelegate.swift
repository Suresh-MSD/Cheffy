//
//  AppDelegate.swift
//  chef
//
//  Created by Eddie Ha on 19/7/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import ISMessages
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Initiate the iOS Facebook SDK
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        //Initiate the iOS Google SDK
//        GIDSignIn.sharedInstance().clientID = "785836444326-arm0arq7fqn3n2qp5fvf055qp0tehiok.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance().delegate = self

        
        PayPalMobile .initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "AZGJHw48r-GMMurI819U--nOGSHnI2H61G5AHZk2NreqxuqPa1WRZs-luXwEKqC3VJszT9J5rZ8WpSON",PayPalEnvironmentSandbox: "sb-lyqdb529352@business.example.com"])
        
        GMSServices.provideAPIKey("AIzaSyCKqeku-TrbzwBHME-TF7BEE2eO9X2ZVPU")
        GMSPlacesClient.provideAPIKey("AIzaSyCKqeku-TrbzwBHME-TF7BEE2eO9X2ZVPU")
        
        // Override point for customization after application launch.
        UINavigationBar.appearance().tintColor = OriginalColors.primary.uiColor()
        //ナビゲーションバーの背景を変更
        UINavigationBar.appearance().barTintColor = UIColor.white
        //ナビゲーションのタイトル文字列の色を変更
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : OriginalColors.primary.uiColor()]
        
        IQKeyboardManager.shared.enable = true
        
        //Registering push notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }

        return true
    }
    

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
        UserDefaults.standard.set(token, forKey: "deviceToken")
        print(UserDefaults.standard.object(forKey: "deviceToken")!)
        // 3. Save the token to local storeage and post to app server to generate Push Notification.
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //Sample Payload
        /*{
         "aps" : {
         "alert" : "Cheff Push Testing",
         "sound" : "default",
         "badge" : 1
         }
         }*/
        print("Received push notification: \(userInfo)")
        let aps = userInfo["aps"] as! [String: Any]
        ISMessages.showCardAlert(withTitle: "", message: (aps["alert"] as! String), duration: 2.0, hideOnSwipe: true, hideOnTap: true, alertType: ISAlertType.success, alertPosition: .top, didHide: nil)
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
        //Advertise our app through Facebook
        AppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


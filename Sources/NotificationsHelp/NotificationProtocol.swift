//
//  File.swift
//  
//
//  Created by cristian ayala on 11/02/22.
//

import Foundation
import NotificationCenter
import Firebase



public protocol NotificationsProtocol: UNUserNotificationCenterDelegate, MessagingDelegate{
    func setupNotifications(_ application: UIApplication)
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    func didReceiveTokenWith(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    func didMessaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?)
}

extension NotificationsProtocol {
    public func setupNotifications(_ application: UIApplication) {
        
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        registerNotification(application)
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if #available(iOS 14.0, *) {
            completionHandler([[.banner, .sound]])
        } else {
            completionHandler([[.badge, .sound]])
            // Fallback on earlier versions
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func registerNotification(_ application: UIApplication) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { isGranted, error in
            if let error = error {
                return
            }
            if isGranted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        })
    }
    
    public func didReceiveTokenWith(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    public func didMessaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let tokenDict = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: tokenDict)
    }
    
}

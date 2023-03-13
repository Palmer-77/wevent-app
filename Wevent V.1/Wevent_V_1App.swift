//
//  Wevent_V_1App.swift
//  Wevent V.1
//
//  Created by Palm on 21/4/2564 BE.
//

import SwiftUI
import Firebase
import UserNotifications
import GoogleSignIn
import UserNotifications
import UIKit
import FirebaseMessaging

@main
struct Wevent_V_1App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject,UIApplicationDelegate, GIDSignInDelegate{
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let gcmMessageIDKey = "gcm.message_id"
    
    @AppStorage("log_organizer") var log_organizer = false
    @AppStorage("organizer") var organizer = false
    @AppStorage("log_user") var log_user = false
    @AppStorage("log_switch") var log_switch = false
    @AppStorage("log_status") var log_Status = false
    @AppStorage("log_data") var log_data = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        return true
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
 
      if let error = error {
        
        print(error.localizedDescription)
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (res, err) in
            
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
                
            self.log_Status = true
            
            
            let user = Auth.auth().currentUser
            
            let db = Firestore.firestore()
            
            
            db.collection("Users").document(user?.uid ?? "")
                .getDocument { documentSnapshot, error in
                      guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                      }
                      guard error == nil else {
                        print("error", error ?? "")
                        //self.log_data = true
                        return
                      }
                      if document.exists {
                        print("Have data")
                        self.log_data = false
                        self.log_organizer = (document["organizer"]! as! Int == 1)
                        self.log_user = (document["user"]! as! Int == 1)
                        self.organizer = (document["organizer"]! as! Int == 1)
                        if self.log_organizer == true && self.log_user == true {
                            self.log_switch = true
                        }
                        
                      }
                      else {
                        print("No data")
                        self.log_data = true
                      }
                    }
            
        }
  
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {

    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
 
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    

}


extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    
//    let db = Firestore.firestore()
//    let user = Auth.auth().currentUser
//    
//    let washingtonRef = db.collection("Users").document(user?.uid ?? "")
//    washingtonRef.updateData([
//        "token": "\(fcmToken ?? "")"
//    ]) { err in
//        if let err = err {
//            print("Error updating document: \(err)")
//        } else {
//            print("Document successfully updated")
//        }
//    }
    let dataDict:[String: String] = ["token": fcmToken ?? ""]
    
    print(dataDict)
    print("------------------------------------")
    
  }
  // [END refresh_token]
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // [START_EXCLUDE]
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    // [END_EXCLUDE]
    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.banner,.badge, .sound]])
  }

    
    
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    // [START_EXCLUDE]
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    // [END_EXCLUDE]
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print full message.
    print(userInfo)

    completionHandler()
  }
}
// [END ios_10_message_handling]



//
//  ContentView.swift
//  Wevent V.1
//
//  Created by Palm on 21/4/2564 BE.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn
import SwiftUIRefresh
import UserNotifications

struct ContentView: View {
    @ObservedObject var notificationManager = LocalNotificationManager()
    
    @StateObject var delegate = NotificationDelegte()
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    @AppStorage("log_organizer") var log_organizer = false
    @AppStorage("log_user") var log_user = false
    @AppStorage("log_switch") var log_switch = false
    @EnvironmentObject var userModel : UserModel
    @AppStorage("log_select") var log_select = true
    @AppStorage("log_status") var log_Status = false
    @AppStorage("log_data") var log_data = false
    @AppStorage("log_login") var log_login = false
    @AppStorage("currentPage") var currentPage = 1
    @State var status = false
    @State private var isShowing = false
    
    
    @State var showFootnote = false
    
    var body: some View {
        VStack {
            
            if log_Status{
                if log_data {
                    RegisterView()
                }
                else {
                    if log_switch {
                        ReTest()
                    }
                    else if log_user {
                        UserIndexView()
                    }
                    else if log_organizer {
                        OrganizerIndexView()
                    }
                }
                    
                //UserDefaults.standard.set(true, forKey: "log_status")
            }
            else {
                if currentPage > 3 {
                    Login()
                }
                else {
                    WalkthroughScreen()
                }
                
            }
            
        }.onAppear{
            
            db.collection("Notification").order(by: "timeStamp",descending: true).addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                  print("Error fetching document: \(error!)")
                  return
                }
                guard error == nil else {
                  print("error", error ?? "")
                  //self.log_data = true
                  return
                }
                if document.count != 0 {
                    var num = 0
                    document.documentChanges.forEach { (doc) in
                        let use = doc.document.data()["userIDNotification"] as! [String]
                        if num == 0 {
                            if use.contains(user?.uid ?? ""){
                                print("Have data")
                                  let content = UNMutableNotificationContent()
                                  content.title = "อีเว้นท์ใหม่"
                                  content.subtitle = "\(doc.document.data()["title"] as! String)"
                                  content.sound = UNNotificationSound.default

                                  // show this notification five seconds from now
                                  let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

                                  // choose a random identifier
                                  let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                                  // add our notification request
                                  UNUserNotificationCenter.current().add(request)
                                num+=1
                                db.collection("Notification").document("\(doc.document.data()["notificationID"] as! String)").updateData([
                                    "userIDNotification" : FieldValue.arrayRemove([user?.uid as Any])
                                ]) { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully updated")
                                    }
                                }
                            }
                            
                        }
                        
                        
                    }
                  
                }
                else {
                  print("No data")
                  self.log_data = true
                }
              }
        
            
            
        }
        
    }


}

class NotificationDelegte: NSObject,ObservableObject,UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge,.banner,.sound])
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserModel())
    }
}




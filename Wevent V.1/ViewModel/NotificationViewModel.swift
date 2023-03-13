//
//  NotificationViewModel.swift
//  Wevent V.1
//
//  Created by You Know on 22/6/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn

class NotificationViewModel : ObservableObject{
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    
    @Published var notification : [NotificationModel] = []
    
    
    @Published var noEvent = false
    @Published var newEvent = false
    @Published var updateId = ""
    
    
    init() {
        
        getAllEvents()
    }
    
    func getAllEvents(){
        self.notification.removeAll()
        db.collection("Notification").order(by: "timeStamp", descending: true).addSnapshotListener { (snap, err) in
            guard let docs = snap else{
                self.noEvent = true
                return
                
            }
            
            if docs.documentChanges.isEmpty{
                
                self.noEvent = true
                return
            }
            
            docs.documentChanges.forEach { (doc) in
                
                // Checking If Doc Added...
                if doc.type == .added{
                    let use = doc.document.data()["userID"] as! [String]
                    if use.contains(self.user?.uid ?? ""){
                        
                        let id = doc.document.data()["notificationID"] as! String
                        let title = doc.document.data()["title"] as! String
                        let userID = doc.document.data()["userID"] as! [String]
                        let date = doc.document.data()["date"] as! String
                        let eventID = doc.document.data()["eventID"] as! String
                        
                        self.notification.append(NotificationModel(id: id, title: title, eventID: eventID, date: date, userID: userID))
                            // Sorting All Model..
                            // you can also doi while reading docs...
                    }
                    
                    
                }
                
                
    }
        }
}
}

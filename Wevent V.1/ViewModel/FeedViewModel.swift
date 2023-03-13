//
//  PostModel.swift
//  Wevent V.1
//
//  Created by You Know on 28/5/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn

class FeedViewModel : ObservableObject{
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    
    @Published var feeds : [FeedModel] = []
    
    @Published var noEvent = false
    @Published var newEvent = false
    @Published var updateId = ""
    
    
    init() {
        
        getAllEvents()
    }
    
    func getAllEvents(){
        self.feeds.removeAll()
        db.collection("Feeds").order(by: "timeStamp", descending: true).getDocuments { (snap, err) in
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
                    
                    let id = doc.document.data()["feedID"] as! String
                    let text = doc.document.data()["text"] as! String
                    let userID = doc.document.data()["userID"] as! String
                    let eventID = doc.document.data()["eventID"] as! String
//                    let timeStamp = doc.document.data()["timeStamp"] as! String
                    let date = doc.document.data()["date"] as! String
                    
                    self.feeds.append(FeedModel(id: id, text: text, userID: userID, eventID: eventID, date: date))
                        // Sorting All Model..
                        // you can also doi while reading docs...
                    
                }
                
                
    }
        }
}
}


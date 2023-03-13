//
//  CommentViewModel.swift
//  Wevent V.1
//
//  Created by You Know on 31/5/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn

class CommentViewModel : ObservableObject{
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    
    @Published var comments : [CommentModel] = []
    
    
    @Published var noEvent = false
    @Published var newEvent = false
    @Published var updateId = ""
    
    
    init() {
        
        getAllEvents()
    }
    
    func getAllEvents(){
        self.comments.removeAll()
        db.collection("Comments").order(by: "timeStamp", descending: true).getDocuments { (snap, err) in
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
                    
                    let id = doc.document.data()["commentID"] as! String
                    let comment = doc.document.data()["comment"] as! String
                    let userID = doc.document.data()["userID"] as! String
                    let feedID = doc.document.data()["feedID"] as! String
//                    let timeStamp = doc.document.data()["timeStamp"] as! String
                    let date = doc.document.data()["date"] as! String
                    
                    self.comments.append(CommentModel(id: id, comment: comment, userID: userID, feedID: feedID, date: date))
                        // Sorting All Model..
                        // you can also doi while reading docs...
                    
                }
                
                
    }
        }
}
}


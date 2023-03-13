//
//  UserViewRegister.swift
//  Wevent V.1
//
//  Created by You Know on 9/6/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn

class UserViewRegister: ObservableObject {
    
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    let db2 = Firestore.firestore()
    
    
    @Published var signMember : [SignMemberModel] = []
    
    @Published var noEventHave = false
    @Published var newEventHave = false
    @Published var updateId = ""
    
    
    init() {
        getAllEvents()
    }
    
    func getAllEvents(){
        self.signMember.removeAll()
        db.collection("SignMembers").order(by: "timeStamp", descending: true).addSnapshotListener { (snap, err) in
            guard let docs = snap else{
                self.noEventHave = true
                return
                
            }

            if docs.documentChanges.isEmpty{
                
                self.noEventHave = true
                return
            }
            
            docs.documentChanges.forEach { (doc) in
                    // Checking If Doc Added...
                    if doc.type == .added{

                        
                        let id = doc.document.data()["signMembersID"] as! String
                        let userID = doc.document.data()["userID"] as! String
                        let eventID = doc.document.data()["eventID"] as! String
                        let date = doc.document.data()["date"] as! String
                        
                        
                        self.db2.collection("Users").document("\(userID)").getDocument { [self] (document, error) in
                            if let document = document, document.exists {
                                let data = document.data()
                                                if let data = data {
                                                    let lastname = "\(data["lastName"] as? String ?? "")"
                                                    let name = "\(data["name"] as? String ?? "")"
                                                    let email = "\(data["email"] as? String ?? "")"

                                                    self.signMember.append(SignMemberModel(id: id, userID: userID, eventID: eventID, date: date, name: name, lastName: lastname, email: email))
                                                    
                                                }
                            } else {
                                print("Document does not exist ไม่มีข้อมูล")
                            }
                        }
                        
                    }

            }
        }
    }
}

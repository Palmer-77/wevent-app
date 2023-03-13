//
//  UserModel.swift
//  Wevent V.1
//
//  Created by Palm on 21/4/2564 BE.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseFirestore

class UserModel : ObservableObject{
    @AppStorage("log_organizer") var log_organizer = false
    @AppStorage("log_data") var log_data = false
    @Published var email : String = ""
    @Published var id : String = ""
    @Published  var name: String = ""
    @Published  var lastname: String = ""
    @Published  var sex: String = ""
    @Published  var birthday: String = ""
    @Published  var tel: String = ""
    @Published  var emaillong: String = ""
    @Published  var organizer: Bool = false
    
    init() {
        fetchUser()
    }
    
    func fetchUser(){
        let id = Auth.auth().currentUser?.uid
        
        let db = Firestore.firestore()

        let docRef = db.collection("Users").document("\(id ?? "")")
        
        docRef.addSnapshotListener { [self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                                if let data = data {
                                    print("data", data["name"]as? String ?? "")
                                    self.id = "\(data["id"] as? String ?? "")"
                                    self.email = "\(data["email"] as? String ?? "")"
                                    self.name = "\(data["name"] as? String ?? "") "
                                    self.lastname = "\(data["lastName"] as? String ?? "")"
                                    self.tel = "\(data["tel"] as? String ?? "")"
                                    self.emaillong = "\(data["emaillong"] as? String ?? "")"
                                    self.birthday = "\(data["birthday"] as? String ?? "")"
                                    self.sex = "\(data["sex"] as? String ?? "")"
                                    self.organizer = (data["organizer"]! as! Int == 1)
                                    self.log_organizer = (data["organizer"]! as! Int == 1)
                                    print(self.organizer)

                                    
                                }
                withAnimation(.easeInOut){
                    self.log_data = false
                }
            } else {
                withAnimation(.easeInOut){
                    self.log_data = true
                }
                print("Document does not exist")
            }
        }
        
    }

}

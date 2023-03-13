//
//  EventViewModel.swift
//  Wevent V.1
//
//  Created by Palm on 5/5/2564 BE.
//
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn

class EventViewModel : ObservableObject{
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    
    @Published var events : [EventModel] = []
    
    @Published var noEvent = false
    @Published var newEvent = false
    @Published var updateId = ""
    
    @State var title = ""
    @State var idE = ""
    
    
    init() {
        
        getAllEvents()
    }
    
    func getAllEvents(){
        self.events.removeAll()
        db.collection("Events").whereField("statusEvent", isEqualTo: true).getDocuments { (snap, err) in
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
                    
                    // Retreving And Appending...
                    let storage = Storage.storage().reference()
                    
                    let title = doc.document.data()["title"] as! String
                    let category = doc.document.data()["category"] as! String
                    let path = doc.document.data()["path"] as! String
                    let datestart = doc.document.data()["dateStart"] as! String
                    let dateend = doc.document.data()["dateEnd"] as! String
                    let location = doc.document.data()["location"] as! String
                    let detail = doc.document.data()["detail"] as! String
                    let provinceEvent = doc.document.data()["provinceEvent"] as! String
                    let addressCompany = doc.document.data()["addressCompany"] as! String
                    let formatEvent = doc.document.data()["formatEvent"] as! String
                    let instagram = doc.document.data()["instagram"] as! String
                    let nameCompany = doc.document.data()["nameCompany"] as! String
                    let numpeople = doc.document.data()["numpeople"] as! String
                    let organizerID = doc.document.data()["organizerID"] as! String
                    let tel = doc.document.data()["tel"] as! String
                    let timeEnd = doc.document.data()["timeEnd"] as! String
                    let timeStart = doc.document.data()["timeStart"] as! String
                    let twitter = doc.document.data()["twitter"] as! String
                    let webSite = doc.document.data()["webSite"] as! String
                    let youtube = doc.document.data()["youtube"] as! String
                    let facebook = doc.document.data()["facebook"] as! String
                    let registermembers = doc.document.data()["registermembers"] as! [String]
                    let signmembers = doc.document.data()["signmembers"] as! [String]
                    let email = doc.document.data()["email"] as! String
                    // getting user Data...

                        print(path)
                    self.events.append(EventModel(id: doc.document.documentID, category: category, title: title, datestart: datestart, dateend: dateend, location: location, path: path, detail: detail, provinceEvent: provinceEvent, addressCompany: addressCompany, formatEvent: formatEvent, instagram: instagram, nameCompany: nameCompany, numpeople: numpeople, organizerID: organizerID, tel: tel, timeEnd: timeEnd, timeStart: timeStart, twitter: twitter, webSite: webSite, youtube: youtube, facebook: facebook, registermembers: registermembers, signmembers: signmembers, email: email))
                        // Sorting All Model..
                        // you can also doi while reading docs...
                    
                }
                
                
    }
        }
}
}

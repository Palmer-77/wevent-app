//
//  ShowLikeEventView.swift
//  Wevent V.1
//
//  Created by You Know on 24/6/2564 BE.
//


import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn
import SDWebImageSwiftUI
import RefreshableScrollView

struct ShowLikeEventView: View {
    
    @Binding var showSearch2 : Bool
    
    @State private var isShowing = false
    
    @State var likeMember:[SignMemberModel] = []
    
    @State var url = ""
    
    let db = Firestore.firestore()

    @State var eventID:String
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    @State private var refresh = false
    
    
    var body: some View {
        VStack{
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text("Event Registation")
                            .font(Font.custom("Bebas Neue", size: 40))
                    }
                    //.foregroundColor(.black)
                    Spacer(minLength:0)
                    VStack{
                        Button(action: {
                            self.showSearch2.toggle()
                        }){
                            Image(systemName: "xmark.circle")
                                .font(Font.custom("Bebas Neue", size: 30))
                        }
                    }
                }

            }.padding(.horizontal, 10)
            
            VStack {
                // Search view
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")

                        TextField("search", text: $searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            print("onCommit")
                        }).foregroundColor(.primary)

                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)

                    if showCancelButton  {
                        Button("Cancel") {
                                UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                                self.searchText = ""
                                self.showCancelButton = false
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.horizontal)
                .navigationBarHidden(showCancelButton) // .animation(.default) // animation does not work properly
                

                ScrollView {
                    VStack{
                        
                        if searchText == "" {
                            ForEach(likeMember) { signM in
                                if eventID == signM.eventID {
                                    ListCardLikeUser(signMember: signM)
                                    Divider()
                                }

                            }
                        }
                        else {
                            ForEach(likeMember) { signM in
                                if eventID == signM.eventID {
                                    if signM.name.contains(searchText) || signM.email.contains(searchText) || signM.lastName.contains(searchText) {
                                        ListCardLikeUser(signMember: signM)
                                        Divider()
                                    }
                                }
                                

                            }
                        }
                        
                        Spacer(minLength:0)
                    }.padding()
                    
                    
                }
                
                
                .resignKeyboardOnDragGesture()
            }
        }.onAppear{
            setLike()
        }
    }
    
    func setLike() {
        db.collection("Events").addSnapshotListener { (snap, err) in
            guard let docs = snap else{
                print("")
                return
                
            }

            if docs.documentChanges.isEmpty{
                print("")
                return
            }
            
            docs.documentChanges.forEach { (doc) in
                    // Checking If Doc Added...
                
                if eventID == doc.document.data()["eventID"] as? String {
                    
                    if doc.type == .added{

                        print("likeMember")
                        let id = doc.document.data()["registermembers"] as! [String]
                        let eventID = doc.document.data()["eventID"] as! String
                        
                        for id in id {
                            self.db.collection("Users").document(id).getDocument { [self] (document, error) in
                                if let document = document, document.exists {
                                    let data = document.data()
                                                    if let data = data {
                                                        let lastname = "\(data["lastName"] as? String ?? "")"
                                                        let name = "\(data["name"] as? String ?? "")"
                                                        let email = "\(data["email"] as? String ?? "")"

                                                        self.likeMember.append(SignMemberModel(id: id, userID: id, eventID: eventID, date: " - ", name: name, lastName: lastname, email: email))
                                                        
                                                    }
                                    print("likeMember")
                                } else {
                                    print("Document does not exist ไม่มีข้อมูล")
                                }
                            }

                        }
                                                
                    }
                    
                }
                    

            }
        }
    }
    
}

//
//  CreateFeedView.swift
//  Wevent V.1
//
//  Created by You Know on 27/5/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn
import SDWebImageSwiftUI

struct CreateFeedView: View {
    
    @Binding var showCreateFeed : Bool
    @Binding var eventID : String
    
    let date = Date()
    @State var forDate = ""
    
    @StateObject var eventDataHave = EventViewModel()
    
    var storageManager = StorageManager()
    @State private var image = UIImage()
    @State var url = ""
    @State var post = ""
    @State var show = "คุณคิดอะไรอยู่"
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    @State var id : String = ""
    @State var email : String = ""
    @State var name: String = ""
    @State var lastname: String = ""
    @State var sex: String = ""
    @State var birthday: String = ""
    @State var tel: String = ""
    @State var emailOther: String = ""
    
    var body: some View {
        VStack {
            HStack {
                VStack{
                    
                        Image(systemName: "xmark.circle")
                            .font(Font.custom("Bebas Neue", size: 30))
                            
                    
                }.onTapGesture {
                    self.showCreateFeed.toggle()
                }
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Create Post")
                        .font(Font.custom("Bebas Neue", size: 40))
                }
                
                //.foregroundColor(.black)
                Spacer(minLength:0)
                

                VStack{
                    if post.count != 0{
                        VStack {
                            Button(action: {
                                if eventID == "" {
                                    eventID = "null"
                                }
                                let convert = DateFormatter()
                                
                                convert.dateFormat = "d/MM/YYYY - HH:mm"
                                
                                self.forDate = "\(convert.string(from: date))"
                                
                                var ref: DocumentReference? = nil
                                
                                ref = db.collection("Feeds").addDocument(data: [
                                    "date" : "\(forDate)",
                                    "eventID" : "\(eventID)",
                                    "feedID" : "",
                                    "text" : "\(post)",
                                    "timeStamp" : FieldValue.serverTimestamp(),
                                    "userID" : "\(user?.uid ?? "")"
                                ]) { err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
    //                                    alert.toggle()
    //                                    alertMsg = "\(err)"
                                    } else {
                                        db.collection("Feeds").document(ref?.documentID ?? "").updateData([
                                            "feedID" : "\(ref?.documentID ?? "" )"
                                        ])
                                        self.showCreateFeed.toggle()
                                        print("Document successfully written!")
                                    }
                                }
                            }) {
                            
                            Text("โพสต์")
                                .foregroundColor(.white)
                            }.padding(8)
                        .background(Color.blue)
                        .cornerRadius(8)
                        }
                    }
                    else {
                        VStack {
                            Button(action: {

                            }) {
                            
                            Text("โพสต์")
                                .foregroundColor(.white)
                            }.padding(8)
                        .background(Color.gray)
                        .cornerRadius(8)
                        }
                    }
                }
            }.padding(.bottom, 3)
            HStack{
                VStack {
                    if url != "" {
                        VStack {
//                            Text("User")
//                                .font(Font.custom("Bebas Neue", size: 30))
                            AnimatedImage(url: URL(string: url)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                            .frame(width: 50, height: 50, alignment: .center)
                        
                            
                        }

                    }
                    else {
                        Loader()
                    }
                    
                    
                    //.padding()
                }.onAppear {
                    let storage = Storage.storage().reference()
                    storage.child("Users/Profile/ProfileID-\(user!.uid)").downloadURL{(url,err) in
                        if err != nil {
                            print((err?.localizedDescription)!)
                            return
                        }
                        self.url = "\(url!)"
                    }
                }
                //รูปuser
                VStack(alignment: .leading) {
                    Text("\(name) \(lastname)")
                        .bold()
                    Text(email)
                }
                Spacer()
            }.padding(.bottom, 3)
            
            ScrollView{
                    VStack {
                        ZStack {
                            TextEditor(text: $post)
                                .keyboardType(.default)
                            if post == "" {
                                    TextEditor(text:$show)
                                        .opacity(0.4)
                                        .disabled(true)
                            }
                            
                        }
                    }.padding()
                Spacer()
                VStack{
                    ForEach(eventDataHave.events){ event in
                    if eventID == event.id {
                        EventCardShare(events: event)
                    }
                    }.padding(1)
                }
                
            }
            .onTapGesture {
                        self.endEditing(true)
            }
            
            Spacer()
           

        }.padding(.horizontal, 10)
        .onAppear{
            getUser()
        }

    }
    
    func getUser(){
        db.collection("Users").document(user?.uid ?? "").getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                                if let data = data {
                                    self.email = data["email"] as! String
                                    self.id = data["id"] as! String
                                    self.name = data["name"] as! String
                                    self.lastname = data["lastName"] as! String
                                    self.sex = data["sex"] as! String
                                    self.birthday = data["birthday"] as! String
                                    self.tel = data["tel"] as! String
                                    self.emailOther = data["emailOther"] as! String
                    
                                }
            } else {
                print("Document does not exist ไม่มีข้อมูล")
            }
        }
    }
}

extension View {
        func endEditing(_ force: Bool) {
            UIApplication.shared.windows.forEach { $0.endEditing(force)}
        }
}


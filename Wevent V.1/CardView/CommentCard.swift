//
//  CommentCard.swift
//  Wevent V.1
//
//  Created by You Know on 31/5/2564 BE.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn

struct CommentCard: View {
    var comments : CommentModel
    @State var delectAlert = false
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    @State var url:String = ""
    
    @State var name: String = ""
    @State var lastname: String = ""
    
    @State var noEvent = false
    @State var newEvent = false
    @State var updateId = ""
    
    
    

    
    var body: some View {
        VStack {
            HStack{
                VStack{
                    AnimatedImage(url: URL(string: self.url))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                    .frame(width: 30, height: 30, alignment: .center)
                }.padding(.horizontal, 2)
                VStack{
                    HStack {
                    VStack{
                        HStack{
                            Text("\(name) \(lastname)")
                                .font(.body)
                                .bold()
                            Spacer()
                        }
                        HStack{
                            Text(comments.comment)
                            Spacer()
                        }.font(.callout)
                        Spacer()
                    }
                }.foregroundColor(Color.black)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 3)
                    .background(Color.newECECEC)
                    .cornerRadius(10)
                    VStack{
                        HStack{
                            Text(self.comments.date)
                            Spacer()
                        }.font(.caption)
                    }
                }
                Spacer()
                if comments.userID == user?.uid {
                    VStack{
                        Image(systemName: "trash.circle")
                            .font(.title)
                    }.onTapGesture {
                        self.delectAlert.toggle()
                    }
                }

            }.alert(isPresented:self.$delectAlert) {
                Alert(
                    title: Text("ลบโพสต์"),
                    message: Text("คุณต้องการลบใช่หรือไม่"),
                    primaryButton: .destructive(Text("ใช่")) {
                        db.collection("Comments").document(comments.id).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
                        }
                    },
                    secondaryButton: .cancel(Text("ไม่"))
                )
            }

            
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
        .onAppear {
            getUser()
            let storage = Storage.storage().reference()
            storage.child("Users/Profile/ProfileID-\(comments.userID)").downloadURL{(url,err) in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                self.url = "\(url!)"
            }
        }

        }
    
    
    func getUser(){
        db.collection("Users").document(comments.userID).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                                if let data = data {
                                    self.name = data["name"] as! String
                                    self.lastname = data["lastName"] as! String
                    
                                }
            } else {
                print("Document does not exist ไม่มีข้อมูล")
            }
        }
        


    }

    
    
}

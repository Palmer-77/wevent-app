//
//  PostCard.swift
//  Wevent V.1
//
//  Created by You Know on 28/5/2564 BE.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn

struct PostCard: View {
    @State var detailPostShow = false
    @State var delectAlert = false
    
    @State var comment = ""
    @State var title = ""
    @State var commentTotal = 0
    
    var feeds : FeedModel
    @StateObject var eventDataHave = EventViewModel()
    @StateObject var reFeeds = FeedViewModel()
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    @State var url:String = ""
    
    @State var name: String = ""
    @State var lastname: String = ""
    
    @State var noEvent = false
    @State var newEvent = false
    @State var updateId = ""
    @State var statusEvent = false
    
    
    

    
    var body: some View {
            VStack {
                HStack{
                    VStack{
                        AnimatedImage(url: URL(string: self.url))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                        .frame(width: 40, height: 40, alignment: .center)
                       Spacer()
                    }.padding(.horizontal, 2)
                    VStack{
                        HStack{
                            Text("\(name) \(lastname)")
                                .font(.body)
                                .bold()
                            Spacer()
                        }
                        if feeds.eventID == "" || feeds.eventID == "null" || statusEvent {
                        }
                        else {
                            HStack{
                                VStack {
                                    Text("ได้แชร์ \(title)")
                                    .lineLimit(1)
                                    .font(.caption)
                                }
                                Spacer()
                            }
                        }
                        HStack{
                            Image(systemName: "clock.fill")
                                .font(.caption)
                            Text("\(feeds.date)")
                                .font(.caption)
                            Spacer()
                        }
                        Spacer()
                    }
                   Spacer()
                    if feeds.userID == user?.uid {
                        VStack{
                            Image(systemName: "trash.circle")
                                .font(.title)
                            Spacer()
                        }.onTapGesture {
                            self.delectAlert.toggle()
                        }
                    }
                    
                }.alert(isPresented:self.$delectAlert) {
                    Alert(
                        title: Text("ลบโพสต์"),
                        message: Text("คุณต้องการลบใช่หรือไม่"),
                        primaryButton: .destructive(Text("ใช่")) {
                            db.collection("Feeds").document(feeds.id).delete() { err in
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
                VStack{
                    HStack{
                            Text(feeds.text)
                                .font(Font.system(size: 16))
                        Spacer()
                        
                    }.padding(.horizontal,10)
                    .padding(.bottom,5)
                        VStack{
                            ForEach(eventDataHave.events){ event in
                                if feeds.eventID == event.id {
                                    EventCardShare(events: event)
                                }
                            }
                        }
                    HStack{
                        Spacer()
                        Text("ความคิดเห็น \(commentTotal) รายการ")
                            .font(.caption)
                    }
                }.padding(.bottom,4)
                .padding(.top,1)
                Divider()
                VStack{
                    VStack{
                        VStack {
                            TextField("แสดงความคิดของคุณ",text: $comment)
                                .disabled(true)
                        }.padding(10)
                    }.frame(height: 45)
                    .cornerRadius(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.newECECEC,lineWidth: 1)
                            .opacity(0.3)
                    )
                    .onTapGesture {
                        self.detailPostShow.toggle()
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical)
            
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.newECECEC,lineWidth: 1)
                    .opacity(0.3)
            )
            .cornerRadius(10)
            .onTapGesture {
                self.detailPostShow.toggle()
            }
            .fullScreenCover(isPresented: self.$detailPostShow) {
                    PostDetailView(detailPostShow: self.$detailPostShow, feeds: feeds)
            }
            .onAppear {
                getUser()
                let storage = Storage.storage().reference()
                storage.child("Users/Profile/ProfileID-\(feeds.userID)").downloadURL{(url,err) in
                    if err != nil {
                        print((err?.localizedDescription)!)
                        return
                    }
                    self.url = "\(url!)"
                }
                db.collection("Events").document(feeds.eventID).getDocument { [self] (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                                        if let data = data {
                                            print("มี \(data)")
                            
                                        }
                    } else {
                        self.statusEvent = true
                        print("Document does not exist ไม่มีข้อมูล")
                    }
                }
            }

    }
    
    
    func getUser(){
        db.collection("Users").document(feeds.userID).getDocument { [self] (document, error) in
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
        db.collection("Events").document(feeds.eventID).getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                                if let data = data {
                                    self.title = data["title"] as! String
                    
                                }
            } else {
                print("Document does not exist ไม่มีข้อมูล")
            }
        }
        db.collection("Comments").whereField("feedID", isEqualTo: "\(feeds.id)").addSnapshotListener { (snap, err) in
            guard let docs = snap else{
                print("num")
                return
            }
                self.commentTotal = docs.count
                print(docs.count)
            
        }

    }

    
    
}

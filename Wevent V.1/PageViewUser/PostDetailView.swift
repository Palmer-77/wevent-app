//
//  PostDetailView.swift
//  Wevent V.1
//
//  Created by You Know on 31/5/2564 BE.
//

import SwiftUI
import SDWebImageSwiftUI

import Firebase
import FirebaseStorage
import FirebaseFirestore
import RefreshableScrollView

struct PostDetailView: View {
    @State private var isShowing = false
    @State private var refresh = false
    @State var delectAlert = false
    @Binding var detailPostShow:Bool
    @State var comment = ""
    @State var title = ""
    @State var show = "แสดงความคิดเห็นของคุณ"
    let date = Date()
    @State var forDate = ""
    @State var commentTotal = 0
    
    var feeds : FeedModel
    @StateObject var eventDataHave = EventViewModel()
    @StateObject var commentData = CommentViewModel()
    
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
        
        RefreshableScrollView(refreshing: $refresh, action: {
            // add your code here
            // remmber to set the refresh to false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.refresh = false
                commentData.getAllEvents()
            }
        }){
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10.0) {
                            Text("Post Detail")
                                .font(Font.custom("Bebas Neue", size: 40))
                        }
                        
                        //.foregroundColor(.black)
                        Spacer(minLength:0)
                        
                        VStack{
                            Button(action: {
                                self.detailPostShow.toggle()
                            }){
                                Image(systemName: "xmark.circle")
                                    .font(Font.custom("Bebas Neue", size: 30))
                            }
                        }
                    }
                    
                }.padding(.horizontal, 10)
                .padding(.bottom, 1)
            
            
            VStack{
                
                    VStack {
                        HStack{
                            VStack{
                                AnimatedImage(url: URL(string: self.url))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                                .frame(width: 50, height: 50, alignment: .center)
                                Spacer()
                            }.padding(.horizontal, 2)
                            VStack{
                                HStack{
                                    Text("\(name) \(lastname)")
                                        .font(.body)
                                        .bold()
                                    Spacer()
                                }
                                if feeds.eventID == "" || feeds.eventID == "null" {
                                    

                                }
                                else {
                                    HStack{
                                        Text("ได้แชร์ \(title)")
                                            .lineLimit(1)
                                            .font(.caption)
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
                        }.padding(.bottom,1)
                        .alert(isPresented:self.$delectAlert) {
                            Alert(
                                title: Text("ลบโพสต์"),
                                message: Text("คุณต้องการลบใช่หรือไม่"),
                                primaryButton: .destructive(Text("ใช่")) {
                                    db.collection("Feeds").document(feeds.id).delete() { err in
                                        if let err = err {
                                            print("Error removing document: \(err)")
                                        } else {
                                            print("Document successfully removed!")
                                            self.detailPostShow.toggle()
                                        }
                                    }
                                },
                                secondaryButton: .cancel(Text("ไม่"))
                            )
                        }
                        
                        HStack{
                                Text(feeds.text)
                                    .font(Font.system(size: 16))
                                    .bold()
                            Spacer()
                            
                        }.padding(.horizontal,10)
                        .padding(.bottom,5)
                        
//                        VStack(alignment: .leading){
//                            Text(feeds.text)
//                                .font(.callout)
//                        }.padding(.bottom,5)
//                        .padding(.horizontal,10)

                        VStack{
                            ForEach(eventDataHave.events){ event in
                                if feeds.eventID == event.id {
                                    EventCardShare(events: event)
                                }
                            }
                        }.padding(.bottom,5)
                        
                        HStack{
                            Spacer()
                            Text("ความคิดเห็น \(commentTotal) รายการ")
                                .font(.caption)
                        }
                        Divider()
                        HStack{
                            VStack{
                                AnimatedImage(url: URL(string: self.url))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                                .frame(width: 35, height: 35, alignment: .center)
                            }
                            VStack {
                                    ZStack {
                                        TextEditor(text: $comment)
                                            .keyboardType(.default)
                                        if comment == "" {
                                                TextEditor(text:$show)
                                                    .opacity(0.4)
                                                    .disabled(true)
                                        }
                                        
                                    }
                            }.padding(5)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.newECECEC,lineWidth: 1)
                                    .opacity(0.4)
                            )
                            VStack{
                                if comment.count != 0 {
                                    Button(action: {
                                        let convert = DateFormatter()
                                        
                                        convert.dateFormat = "d/MM/YYYY - HH:mm"
                                        
                                        self.forDate = "\(convert.string(from: date))"
                                        
                                        var ref: DocumentReference? = nil
                                        
                                        ref = db.collection("Comments").addDocument(data: [
                                            "date" : "\(forDate)",
                                            "feedID" : "\(feeds.id)",
                                            "commentID" : "",
                                            "comment" : "\(comment)",
                                            "timeStamp" : FieldValue.serverTimestamp(),
                                            "userID" : "\(user?.uid ?? "")"
                                        ]) { err in
                                            if let err = err {
                                                print("Error writing document: \(err)")
            //                                    alert.toggle()
            //                                    alertMsg = "\(err)"
                                            } else {
                                                db.collection("Comments").document(ref?.documentID ?? "").updateData([
                                                    "commentID" : "\(ref?.documentID ?? "" )"
                                                ])
                                                self.comment = ""
                                                self.endEditing(true)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    self.isShowing = false
                                                    commentData.getAllEvents()
                                                }
                                                print("Document successfully written!")
                                            }
                                        }
                                    }, label: {
                                        VStack{
                                            Text("ส่ง")
                                                .foregroundColor(Color.white)
                                        }.padding(10)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                    })
                                }
                                else {
                                    Button(action: {
                                        
                                    }, label: {
                                        VStack{
                                            Text("ส่ง")
                                                .foregroundColor(Color.white)
                                        }.padding(10)
                                        .background(Color.gray)
                                        .cornerRadius(10)
                                    })
                                }
                                
                            }
                        }.padding(10)
                        VStack{
                            ForEach(commentData.comments){ commentA in
                                if commentA.feedID == feeds.id {
                                    CommentCard(comments: commentA)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal,1)
                    .padding(.vertical)
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
                    }
                    Spacer()
            }.padding(.horizontal,8)
            //}.padding(.horizontal,10)
            Spacer()
           
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



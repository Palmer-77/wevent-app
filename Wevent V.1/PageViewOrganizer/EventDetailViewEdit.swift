//
//  EventDetailViewEdit.swift
//  Wevent V.1
//
//  Created by You Know on 2/6/2564 BE.
//

import SwiftUI
import SDWebImageSwiftUI

import Firebase
import FirebaseStorage
import FirebaseFirestore

struct EventDetailViewEdit: View {
    @State var numUser:[String] = []
    @State var limitUser:Int = 0
    @State private var showingActionSheet = false
    
    @State var url = ""
    @State var nameUser = ""
    @Binding var detailShowEdit:Bool
    @State private var showCreateFeed = false
    @State var getEditView = false
    @State var getEventRegistationView = false
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    
    var eventDetail : EventModel
    
    
    @AppStorage("dateRe") var dateRe = ""

    
    @State var buttonCheck = false
    
    @State var urlImage:String = ""
    
    @State var id = ""
    
    
    var body: some View {
            ZStack{
                ScrollView {
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 10.0) {
                                Text("Event Detail Edit")
                                    .font(Font.custom("Bebas Neue", size: 40))
                            }

                            //.foregroundColor(.black)
                            Spacer(minLength:0)
                            VStack{
                                Button(action: {
                                    self.detailShowEdit.toggle()
                                }){
                                    Image(systemName: "xmark.circle")
                                        .font(Font.custom("Bebas Neue", size: 30))
                                }
                            }
                        }
                    }.padding(.horizontal, 10)
                    VStack {
                        
                        
                        VStack {
                            AnimatedImage(url: URL(string: self.urlImage))
                                .resizable()
                                .clipped()
                        }.frame(height: 200)
                        .cornerRadius(10)
                        .padding(.horizontal,10)
                        
                        HStack{
                            VStack {
                                if url != "" {
                                    VStack {
                                        Text("Organizer")
                                            .font(Font.custom("Bebas Neue", size: 20))
                                        AnimatedImage(url: URL(string: url)!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle())
                                            .shadow(radius: 10)
                                            .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                                        .frame(width: 80, height: 80, alignment: .center)
                                        Text(nameUser)
                                            .font(Font.custom("Bebas Neue", size: 25))
                                    }
                                }
                                else {
                                    Loader()
                                }
                            }.padding(.horizontal, 5)
                            .onAppear {
                                let storage = Storage.storage().reference()
                                storage.child("Users/Profile/ProfileID-\(eventDetail.organizerID)").downloadURL{(url,err) in
                                    if err != nil {
                                        print((err?.localizedDescription)!)
                                        return
                                    }
                                    self.url = "\(url!)"
                                }
                                
                                db.collection("Users").document(eventDetail.organizerID).addSnapshotListener { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        
                                        self.nameUser = "\(querySnapshot?.data()?["name"] as? String ?? "")"
                                        
                                    }
                            }
                                
                            }
                            //end
                            
                            VStack(alignment: .leading){
                                VStack{
                                    Text(eventDetail.category)
                                        .font(.caption)
                                        .bold()
                                }
                                VStack{
                                    Text(eventDetail.title)
                                        .font(.title2)
                                        .bold()
                                }
                                VStack{
                                    HStack{
                                        VStack{
                                            Image(systemName: "map")
                                                .font(.body)
                                            Spacer()
                                        }
                                        VStack(alignment: .leading){
                                            Text(eventDetail.provinceEvent)
                                                .font(.callout)
                                            Text(eventDetail.location)
                                                .font(.callout)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                    
                                    HStack{
                                        VStack{
                                            Image(systemName: "arrow.up.arrow.down.circle.fill")
                                                .font(.caption)
                                            Spacer()
                                        }
                                        VStack(alignment: .leading){
                                            Text(eventDetail.formatEvent)
                                                .font(.caption)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                    
                                    HStack{
                                        VStack{
                                            Image(systemName: "calendar")
                                                .font(.caption)
                                            Spacer()
                                        }
                                        VStack(alignment: .leading){
                                            Text("\(eventDetail.datestart) - \(eventDetail.dateend)")
                                                .font(.caption)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                    HStack{
                                        VStack{
                                            Image(systemName: "timer")
                                                .font(.caption)
                                            Spacer()
                                        }
                                        VStack(alignment: .leading){
                                            Text("\(eventDetail.timeStart) - \(eventDetail.timeEnd)")
                                                .font(.caption)
                                            Spacer()
                                        }
                                        Spacer()
                                    }

                                }
           
                            }
                        }.padding(.horizontal, 10)
                        VStack{
                            
                        }
                        Divider()
                            .padding(.horizontal,10)
                        HStack{
                            VStack(alignment: .leading){
                                Text("รายละเอียด")
                                    .font(.title2)
                                Text(eventDetail.detail)
                                    .font(.title3)
                            }
                            Spacer()
                        }.padding(.horizontal,10)
                        Divider()
                            .padding(.horizontal,10)
                        
                        VStack(alignment: .leading){
                            Text("การติดต่อ")
                                .font(.title2)
                            HStack{
                                VStack{
                                    Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                        .font(.title3)
                                }
                                VStack(alignment: .leading){
                                    Text("บริษัท/หน่วยงาน : \(eventDetail.nameCompany)")
                                        .font(.title3)
                                }
                                Spacer()
                            }//.padding(.horizontal,10)
                            HStack{
                                VStack{
                                    Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                        .font(.title3)
                                }
                                VStack(alignment: .leading){
                                    Text("ที่อยู่ : \(eventDetail.addressCompany)")
                                        .font(.title3)
                                }
                                Spacer()
                            }//.padding(.horizontal,10)
                            HStack{
                                VStack{
                                    Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                        .font(.title3)
                                }
                                VStack(alignment: .leading){
                                    Text("Email : \(eventDetail.email)")
                                        .font(.title3)
                                }
                                Spacer()
                            }//.padding(.horizontal,10)
                            HStack{
                                VStack{
                                    Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                        .font(.title3)
                                }
                                VStack(alignment: .leading){
                                    //Link("Tel : \(eventDetail.tel)", destination: URL(string: "tel:\(eventDetail.tel)")!)
                                    Text("Tel : \(eventDetail.tel)")
                                        .font(.title3)
                                }
                                Spacer()
                            }//.padding(.horizontal,10)
                            HStack{
                                VStack{
                                    Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                        .font(.title3)
                                }
                                VStack(alignment: .leading){
                                    //Link("Website : \(eventDetail.webSite)", destination: URL(string: "\(eventDetail.webSite)")!)
                                    Text("Website : \(eventDetail.webSite)")
                                        .font(.title3)
                                }
                                Spacer()
                            }//.padding(.horizontal,10)
                        }.padding(.horizontal,10)
                        
                        Divider()
                            .padding(.horizontal,10)
                        VStack(alignment: .leading){
                            Text("สังคมออนไลน์")
                                .font(.title2)
                            HStack{
                                VStack{
                                    Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                        .font(.title3)
                                }
                                VStack(alignment: .leading){
                                    Text("Facebook : \(eventDetail.facebook)")
                                        .font(.title3)
                                }
                                Spacer()
                            }//.padding(.horizontal,10)
                            HStack{
                                VStack{
                                    Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                        .font(.title3)
                                }
                                VStack(alignment: .leading){
                                    Text("Youtube : \(eventDetail.youtube)")
                                        .font(.title3)
                                }
                                Spacer()
                            }//.padding(.horizontal,10)
                            HStack{
                                VStack{
                                    Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                        .font(.title3)
                                }
                                VStack(alignment: .leading){
                                    Text("Twitter : \(eventDetail.twitter)")
                                        .font(.title3)
                                }
                                Spacer()
                            }//.padding(.horizontal,10)
                            HStack{
                                VStack{
                                    Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                        .font(.title3)
                                }
                                VStack(alignment: .leading){
                                    Text("Instagram : \(eventDetail.instagram)")
                                        .font(.title3)
                                }
                                Spacer()
                            }//.padding(.horizontal,10)

                        }.padding(.horizontal,10)
                        
                        Spacer()
                    }.onAppear {
                        let storage = Storage.storage().reference()
                        storage.child("Events/Banner/\(eventDetail.path)").downloadURL{(url,err) in
                            if err != nil {
                                print((err?.localizedDescription)!)
                                return
                            }
                            self.urlImage = "\(url!)"
                        }
                    }
                }.onAppear {
                    self.id = eventDetail.id
                    db.collection("Events").document(eventDetail.id).addSnapshotListener { (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                } else {
                                    
                                    let registers = querySnapshot?.data()!["registermembers"] as! [String]
                                    for register in registers {
                                        //let register = document.data()["registermember"] as! String
                                        if register == user?.uid {
                                            self.buttonCheck = true
                                            break
                                        }
                                        print(self.buttonCheck)
                                    }
                                }
                        }
                }
                .padding(.bottom,50)
                
                Spacer()
                VStack{
                    Spacer()
                    HStack{
                        VStack {
                            Button(action: {
                                self.getEventRegistationView.toggle()
                            }) {
                                VStack{
                                    Text("การลงทะเบียนเข้าร่วมอีเว้นท์")
                                        .foregroundColor(Color.white)
                                }.padding(.vertical,10)
                                .padding(.horizontal,10)
                                .background(Color.newGreenK)
                                .cornerRadius(10)
                                
                            }
                        }.padding(5)
                        .fullScreenCover(isPresented: $getEventRegistationView ){
                            EventRegistationView(getEventRegistationView: $getEventRegistationView, eventDetail: eventDetail)
                        }
                        Spacer()
                        VStack{
                            Image(systemName: "filemenu.and.selection")
                                .foregroundColor(Color.black)
                                .font(.title)
                                .onTapGesture {
                                    self.showingActionSheet = true
                                }
                                .actionSheet(isPresented: $showingActionSheet) {
                                    ActionSheet(title: Text("จัดการอีเว้นท์"), buttons: [.default(Text("แก้ไข")){
                                            self.getEditView = true
                                    },.default(Text("ลบ")){
                                        
                                    }, .cancel()])
                                }
                        }.padding(5)

                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .background(
                        RoundedCorners(color: Color.white, tl: 10, tr: 10, bl: 0, br: 0)
                            //.opacity(0.5)
                        )
                    .fullScreenCover(isPresented: $getEditView ){
                        EditEventView(getEditView: $getEditView, eventDetail: eventDetail)
                    }
                    
                }
            }
            
            .onAppear{
                getUsertotal()
            }
        
            
        

    }
    func getUsertotal() {
        db.collection("Events").document(eventDetail.id).addSnapshotListener { (snap, err) in
            guard let docs = snap else{
                print("num")
                return
            }
            if docs.exists {
                self.numUser = docs.data()?["registermembers"] as! [String]
                self.limitUser = Int(docs.data()?["numpeople"] as! String) ?? 0
                print(numUser.count)
            }
        }

    }
            
}



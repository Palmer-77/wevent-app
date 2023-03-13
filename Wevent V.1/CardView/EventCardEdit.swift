//
//  EventCardEdit.swift
//  Wevent V.1
//
//  Created by You Know on 26/5/2564 BE.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn

struct EventCardEdit: View {
    @State var detailShowEdit = false
    
    var events : EventModel
    //@ObservedObject var eventData : EventViewModel
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    @State var category:String = ""
    @State var title:String = ""
    @State var datestart:String = ""
    @State var dateend:String = ""
    @State var location:String = ""
    @State var urlImage:String = ""
    
    var event : [EventModel] = []
    
    @State var noEvent = false
    @State var newEvent = false
    @State var updateId = ""
    
    @State var numUser:[String] = []
    @State var regisUser:[String] = []
    

    
    var body: some View {
        VStack {
                VStack(alignment: .leading) {
                    ZStack(alignment: .topTrailing) {
                        
                        AnimatedImage(url: URL(string: self.urlImage))
                            .resizable()
                                //.scaledToFit()
                                .frame(height: 200, alignment: .center)
                                .clipped()
                        
                        VStack(alignment: .trailing){
                            VStack{
                                    HStack{
                                Image(systemName: "person.2.circle.fill")
                                Text("ลงทะเบียน \(self.numUser.count)")
                                    }.font(.callout)
                                    .foregroundColor(Color.black)
                                    .padding(5)
                            .cornerRadius(10)
                            }.background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                            )
                            .padding(.bottom,4)
                            VStack{
                                    HStack{
                                Image(systemName: "person.crop.circle.fill.badge.checkmark")
                                Text("เข้าร่วมงาน \(self.regisUser.count)")
                                    }.font(.callout)
                                    .foregroundColor(Color.black)
                                    .padding(5)
                            .cornerRadius(8)
                            }.background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                            )
                        }
                        .padding(10)

                        
                        
                    }.onAppear {
                        let storage = Storage.storage().reference()
                        storage.child("Events/Banner/\(events.path)").downloadURL{(url,err) in
                            if err != nil {
                                print((err?.localizedDescription)!)
                                return
                            }
                            self.urlImage = "\(url!)"
                        }
                    }

                        VStack(alignment: .leading) {
                            Text(events.category)
                                .font(.headline)
                                .foregroundColor(.black)
                            Text(events.title)
                                .font(.body)
                                .foregroundColor(.black)
                                .lineLimit(3)
                            Text("\(events.datestart) - \(events.dateend)")
                                .font(.caption)
                                .foregroundColor(.black)
                            Text("\(events.location)")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)

                    
                }
                
                
                

            
        }.background(Color.newECECEC)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        .onTapGesture {
            self.detailShowEdit.toggle()
        }
        .fullScreenCover(isPresented: self.$detailShowEdit) {
            EventDetailViewEdit(detailShowEdit: self.$detailShowEdit, eventDetail: events)
        }
        .onAppear{
            getUsertotal()
        }
        .padding(.vertical, 5)
        

        }
    
    func getUsertotal() {
        db.collection("Events").document(events.id).addSnapshotListener { (snap, err) in
            guard let docs = snap else{
                print("num")
                return
            }
            if docs.exists {
                self.numUser = docs.data()?["registermembers"] as! [String]
                self.regisUser = docs.data()?["signmembers"] as! [String]
                //print(numUser.count)
            }
        }

    }
    
}

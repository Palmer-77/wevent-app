//
//  EventCard.swift
//  Wevent V.1
//
//  Created by Palm on 4/5/2564 BE.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn

struct EventCard: View {
    @State var detailShow = false
    @State var limitUser:Int = 0
    
    var events : EventModel
    //@ObservedObject var eventData : EventViewModel
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    @State var urlImage:String = ""
    
    var event : [EventModel] = []
    
    @State var noEvent = false
    @State var newEvent = false
    @State var updateId = ""
    
    @State var numUser:[String] = []
    

    
    var body: some View {
        VStack {
                VStack(alignment: .leading) {
                    ZStack(alignment: .topTrailing) {
                        
                        AnimatedImage(url: URL(string: self.urlImage))
                            .resizable()
                                //.scaledToFit()
                                .frame(height: 200, alignment: .center)
                                .clipped()
                        VStack{
                                HStack{
                            Image(systemName: "person.2.circle.fill")
                            Text("\(self.numUser.count)/\(limitUser)")
                                }.font(.callout)
                                .foregroundColor(Color.black)
                                .padding(5)
                        .cornerRadius(8)
                        }.background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                        )
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
                        }.padding(.horizontal, 10)
                        .padding(.vertical, 10)

                    
                }.onTapGesture {
                    self.detailShow.toggle()
                }
                .fullScreenCover(isPresented: self.$detailShow) {
                    EventDetailView(detailShow: self.$detailShow, eventDetail: events)
                }
                
                //.padding([.top, .horizontal])

            
        }.background(Color.newECECEC)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        .padding(.bottom,8)
        .onAppear{
            getUsertotal()
        }

        }
    
    func getUsertotal() {
        db.collection("Events").document(events.id).addSnapshotListener { (snap, err) in
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

//struct EventCard_Previews: PreviewProvider {
//    static var previews: some View {
//        EventCard()
//    }
//}

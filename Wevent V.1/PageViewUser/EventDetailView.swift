//
//  EventDetailView.swift
//  Wevent V.1
//
//  Created by Palm on 5/5/2564 BE.
//

import SwiftUI
import SDWebImageSwiftUI

import Firebase
import FirebaseStorage
import FirebaseFirestore

struct EventDetailView: View {
    @State var numUser:[String] = []
    @State var limitUser:Int = 0
    
    @State var url = ""
    @State var nameUser = ""
    @Binding var detailShow:Bool
    @State private var showCreateFeed = false
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    
    var eventDetail : EventModel
    
    @State var joining = false
    
    
    @AppStorage("dateRe") var dateRe = ""

    
    @State var buttonCheck = false
    
    @State var urlImage:String = ""
    
    @State var id = ""
    
    @State var alertSing = false
    
    
    var body: some View {
        
        ZStack{
            ScrollView {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10.0) {
                            Text("Event Detail")
                                .font(Font.custom("Bebas Neue", size: 40))
                        }
                        
                        //.foregroundColor(.black)
                        Spacer(minLength:0)
                        
                        VStack{
                            Button(action: {
                                self.detailShow.toggle()
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
                                .font(.title)
                            Text(eventDetail.detail)
                                .font(.body)
                        }
                        Spacer()
                    }.padding(.horizontal,10)
                    Divider()
                        .padding(.horizontal,10)
                    
                    VStack(alignment: .leading){
                        Text("ข้อมูลบริษัท")
                            .font(.title)
                        HStack{
                            VStack{
                                Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                    .font(.body)
                            }
                            VStack(alignment: .leading){
                                Text("บริษัท/หน่วยงาน : \(eventDetail.nameCompany)")
                                    .font(.body)
                            }
                            Spacer()
                        }//.padding(.horizontal,10)
                        HStack{
                            VStack{
                                Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                    .font(.body)
                            }
                            VStack(alignment: .leading){
                                Text("ที่อยู่ : \(eventDetail.addressCompany)")
                                    .font(.body)
                            }
                            Spacer()
                        }//.padding(.horizontal,10)
                        HStack{
                            VStack{
                                Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                    .font(.body)
                            }
                            VStack(alignment: .leading){
                                Button(action: {
                                    if let url = URL(string: "mailto:\(eventDetail.email)") {
                                        if #available(iOS 14.0, *) {
                                        UIApplication.shared.open(url)
                                      } else {
                                        UIApplication.shared.openURL(url)
                                      }
                                    }
                                }, label: {
                                    Text("Email : \(eventDetail.email)")
                                        .font(.body)
                                })
                                
                            }
                            Spacer()
                        }//.padding(.horizontal,10)
                        HStack{
                            VStack{
                                Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                    .font(.body)
                            }
                            VStack(alignment: .leading){
                                if eventDetail.tel == "" {
                                    Text("Tel : \(eventDetail.tel)")
                                        .font(.body)
                                }
                                else {
                                    Link("Tel : \(eventDetail.tel)", destination: URL(string: "tel:\(eventDetail.tel)")!)
                                        .font(.body)
                                }
                            }
                            Spacer()
                        }//.padding(.horizontal,10)
                        HStack{
                            VStack{
                                Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                    .font(.body)
                            }
                            VStack(alignment: .leading){
                                if eventDetail.webSite == "" || eventDetail.webSite.contains("http") == false {
                                    Text("Website : \(eventDetail.webSite)")
                                        .font(.body)
                                }
                                else {
                                    Link("Website : \(eventDetail.webSite)", destination: URL(string: "\(eventDetail.webSite)")!)
                                        .font(.body)
                                }
                            }
                            Spacer()
                        }//.padding(.horizontal,10)
                    }.padding(.horizontal,10)
                    
                    Divider()
                        .padding(.horizontal,10)
                    VStack(alignment: .leading){
                        Text("ช่องติดต่อออนไลน์")
                            .font(.title)
                        HStack{
                            VStack{
                                Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                    .font(.body)
                            }
                            VStack(alignment: .leading){
                                Text("Facebook : \(eventDetail.facebook)")
                                    .font(.body)
                            }
                            Spacer()
                        }//.padding(.horizontal,10)
                        HStack{
                            VStack{
                                Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                    .font(.body)
                            }
                            VStack(alignment: .leading){
                                Text("Youtube : \(eventDetail.youtube)")
                                    .font(.body)
                            }
                            Spacer()
                        }//.padding(.horizontal,10)
                        HStack{
                            VStack{
                                Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                    .font(.body)
                            }
                            VStack(alignment: .leading){
                                Text("Twitter : \(eventDetail.twitter)")
                                    .font(.body)
                            }
                            Spacer()
                        }//.padding(.horizontal,10)
                        HStack{
                            VStack{
                                Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                    .font(.body)
                            }
                            VStack(alignment: .leading){
                                Text("Instagram : \(eventDetail.instagram)")
                                    .font(.body)
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
                checkUSer()
            }
            .padding(.bottom,50)
            
            Spacer()
            VStack{
                Spacer()
                HStack{
                    VStack(alignment: .center){
                        HStack{
                            Text("แชร์")
                            Image(systemName: "square.and.arrow.up")
                        }
                        .font(.body)
                        .foregroundColor(Color.black)
                    }.padding(.horizontal)
                    .onTapGesture {
                        self.showCreateFeed.toggle()
                    }
                    .fullScreenCover(isPresented: self.$showCreateFeed) {
                        CreateFeedView(showCreateFeed: self.$showCreateFeed, eventID: self.$id)
                    }
                    Spacer()
                    VStack{
                        HStack{
                            Image(systemName: "person.2.fill")
                            Text("\(numUser.count)/\(limitUser) คน")
                        }.font(.body)
                        .foregroundColor(Color.black)
                    }
                    Spacer()
                    if user!.isEmailVerified {
                        if buttonCheck {
                            if joining {
                                VStack{
                                    Text("คุณร่วมงานแล้ว")
                                        .font(.body)
                                        .bold()
                                        .padding()
                                        .foregroundColor(Color.white)
                                }.frame(height: 40, alignment: .center)
                                .background(Color.black)
                                .cornerRadius(10)
                                .padding(8)
                            }
                            else {
                                VStack(alignment: .center){
                                    Button(action:{
                                        db.collection("Events").document(eventDetail.id).updateData([
                                            "registermembers" : FieldValue.arrayRemove([user?.uid as Any])
                                        ]){ err in
                                            if let err = err {
                                                print("Error writing document: \(err)")
                                            } else {
                                                print("Document successfully written!")
                                                self.alertSing = false
                                                self.detailShow.toggle()
                                            }
                                        }
                                    }){
                                        VStack{
                                            Text("ยกเลิก")
                                            .font(.body)
                                                .padding()
                                                .foregroundColor(Color.black)
                                        }.frame(height: 40, alignment: .center)
                                        .background(Color.red)
                                        .cornerRadius(10)
                                        
                                    }
                                }.padding(8)
                            }
                        }
                        else {
                                VStack(alignment: .center){
                                    Button(action:{
                                        db.collection("Events").document(eventDetail.id).updateData([
                                            "registermembers" : FieldValue.arrayUnion([user?.uid as Any])
                                        ]){ err in
                                            if let err = err {
                                                print("Error writing document: \(err)")
                                            } else {
                                                print("Document successfully written!")
                                                self.alertSing.toggle()
                                            }
                                        }
                                    }){
                                        VStack{
                                            Text("เข้าร่วม")
                                            .font(.body)
                                                .padding()
                                                .foregroundColor(Color.black)
                                        }.frame(height: 40, alignment: .center)
                                        .background(Color.newECECEC)
                                        .cornerRadius(10)
                                        
                                    }
                                }.padding(8)
                        }
                    }
                    else {
                        HStack{
                            Image(systemName: "person.crop.circle.badge.exclamationmark")
                            Text("คุณยังไม่ยืนยันตัวตน")
                                .font(.body)
                                .bold()
                                
                        }.foregroundColor(Color.red)
                        .frame(height: 40, alignment: .center)
                        .padding(5)
                        .background(
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red,lineWidth: 2)
                            }
                        )
                        .cornerRadius(10)
                        .padding(8)
                    }
                    
                    
                    
                }
                .background(
                    RoundedCorners(color: Color.white, tl: 10, tr: 10, bl: 0, br: 0)
                        //.opacity(0.5)
                    )
            }
        }.onAppear{
            getUsertotal()
            checkUSer()
        }
        .alert(isPresented: $alertSing) {
            Alert(title: Text("แจ้งเตือน"), message: Text("ลงทะเบียนเข้าร่วมเรียบร้อย"), dismissButton: .default( Text("ตกลง")){
                checkUSer()
            }
            )
        }

    }
    func checkUSer() {
        self.id = eventDetail.id
        db.collection("Events").document(eventDetail.id).addSnapshotListener { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        
                        let registers = querySnapshot?.data()?["registermembers"] as! [String]
                        if registers.contains(user?.uid ?? "") {
                                self.buttonCheck = true
                            }
                            else {
                                self.buttonCheck = false
                            }
                        
                        let signmembers = querySnapshot?.data()?["signmembers"] as! [String]
                        if signmembers.contains(user?.uid ?? "") {
                                self.joining = true
                            }
                            else {
                                self.joining = false
                            }
                    }
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

struct RoundedCorners: View {
    var color: Color = .blue
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    var body: some View {
        GeometryReader { geometry in
            Path { path in

                let w = geometry.size.width
                let h = geometry.size.height

                // Make sure we do not exceed the size of the rectangle
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)

                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            }
            .fill(self.color)
        }
        
    }
    
}

//struct EventDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDetailView()
//    }
//}

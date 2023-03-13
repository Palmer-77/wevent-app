//
//  UserSearchView.swift
//  Wevent V.1
//
//  Created by You Know on 25/5/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn
import RefreshableScrollView





struct UserSearchView: View {
    
    struct CategoryModel: Identifiable {
        var id : Int
        var titile : String
        var icon : String
        var img : String
    }
    
    

    @State var showSearch = false
    
    @State var selectedCategory = "แนะนำ"
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    @StateObject var eventsSearch = EventViewSearch()
    @StateObject var eventsSearchHot = EventViewSearchHot()
    
    @State private var isShowing = false
    @State private var refresh = false
    
    
    @State var url = ""
    
    @State var categoryUserSel:[String] = []
    
    
    @State var selected = ""
    @State var show = false
    
    let categorys:[CategoryModel] = [
    CategoryModel(id: 0, titile: "แนะนำ", icon: "star.fill",img:"Wevent-2"),
    CategoryModel(id: 1, titile: "มาแรง", icon: "flame.fill",img:"Wevent-2"),
    CategoryModel(id: 2, titile: "ทั้งหมด", icon: "tray.full.fill",img:"Wevent-2"),
    CategoryModel(id: 3, titile: "ครอบครัวและเด็ก", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 4, titile: "บ้านและการตกแต่ง", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 5, titile: "การ์ตูนและเกม", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 6, titile: "การพัฒนาตนเอง", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 7, titile: "การศึกษา", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 8, titile: "เทศกาลและประเพณี", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 9, titile: "รถยนต์และยานพาหนะ", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 10, titile: "แฟชั่น", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 11, titile: "การเงินและธนาคาร", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 12, titile: "ไอทีและเทคโนโลยี", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 13, titile: "สุขภาพและความงาม", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 14, titile: "ดนตรีและการแสดง", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 15, titile: "พืชและสัตว์", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 16, titile: "เพื่อสังคม", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 17, titile: "งานและอาชีพ", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 18, titile: "อุตสาหกรรม", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 19, titile: "แต่งงาน", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 20, titile: "ศิลปะและการออกแบบ", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 21, titile: "กีฬาและสันทนาการ", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 22, titile: "หนังสือ", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 23, titile: "ธุรกิจ", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 24, titile: "อาหารและเครื่องดื่ม", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 25, titile: "ท่องเที่ยว", icon: "pencil.circle",img:"Wevent-2"),
    CategoryModel(id: 26, titile: "ช้อปปิ้ง", icon: "pencil.circle",img:"Wevent-2"),
        ]
    
    init() {
        reComEvent()
    }
    
    var body: some View {
        VStack{
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text("Search")
                            .font(Font.custom("Bebas Neue", size: 40))
                    }
                    
                    //.foregroundColor(.black)
                    Spacer(minLength:0)
                    
                    //.foregroundColor(.black)
                    VStack(alignment: .trailing, spacing: 10.0) {
                        Image(systemName: "qrcode.viewfinder")
                            .font(Font.custom("Bebas Neue", size: 30))
                    }
                    //.foregroundColor(.black)
                } .padding(.vertical, 5)
    
            }.padding(.horizontal, 10)
            .padding(.bottom,1)
            
            VStack {
            
                VStack(alignment: .leading){
                    Text("คุณสนใจอะไร")
                        .font(.title)
                        .bold()
                
                    ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        VStack{
                            Button(action: {
                                self.showSearch.toggle()
                            }){
                                VStack(alignment: .center){
                                    Text("ค้นหา")
                                        .font(Font.body.bold())
                                }
                                .frame(width: 74, height: 74, alignment: .center)
                                .font(UIScreen.main.bounds.height < 750 ? .caption : .body)
                                .foregroundColor(Color.black)
                                .padding(.vertical,8)
                                .padding(.horizontal,10)
                                .background(ZStack{
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black,lineWidth: 1)
                                })
                            }

                        }.fullScreenCover(isPresented: $showSearch){
                            SearchEventView(showSearch: self.$showSearch, eventsSearch: eventsSearch.eventsSearch)
                        }
                                                
                        
                        
                        ForEach(categorys){ category in
                            
                            Button(action: {
                                selectedCategory = category.titile
                            }) {
                                    
                                
                                VStack(alignment: .center){
                                    Image(systemName: category.icon)
                                    Text("\(category.titile)")
                                }
                                .font(Font.body.bold())
                                .frame(width: 74, height: 74, alignment: .center)
                                    .font(UIScreen.main.bounds.height < 750 ? .caption : .body)
                                    .foregroundColor(selectedCategory == category.titile ? .white : .black)
                                    .padding(.vertical,8)
                                    .padding(.horizontal,10)
                                    
                                    .background(
                                    
                                        ZStack{
                                            
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.black.opacity(selectedCategory == category.titile ? 0.85 : 0.15))
                                            
                                            VStack{
                                                Image(category.img)
                                                    .resizable()
                                                    .opacity(0.4)
                                                    .cornerRadius(10)
                                            }
                                            
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.blue,lineWidth: 1)
                                            
                                            
                                        }
                                    )
                                
                            }
                        }
                    }.frame(height: 100)
                    .padding(1)
                    }.padding(.top,1)
                    
                    

                    
                
                }.padding(.horizontal, 5)
                
                
                VStack{
                    RefreshableScrollView(refreshing: $refresh, action: {
                        // add your code here
                        // remmber to set the refresh to false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.refresh = false
                            eventsSearch.getAllEvents()
                        }
                    }){
                        VStack{
                            if selectedCategory == "มาแรง" {
                                ForEach(eventsSearchHot.eventsSearchHot) { eventsSearchH in
                                        EventCard(events: eventsSearchH)
                                }
                            }
                            else if selectedCategory == "ทั้งหมด" {
                                ForEach(eventsSearch.eventsSearch) { eventsSearchs in
                                        EventCard(events: eventsSearchs)
                                }
                            }
                            else if selectedCategory == "แนะนำ" {
                                ForEach(eventsSearch.eventsSearch) { eventsSearchs in
                                    if categoryUserSel.contains(eventsSearchs.category){
                                        EventCard(events: eventsSearchs)
                                    }
                                }
                            }
                            else {
                                ForEach(eventsSearch.eventsSearch) { eventsSearchs in
                                    if selectedCategory == eventsSearchs.category{
                                        EventCard(events: eventsSearchs)
                                            
                                    }
                                }
                            }
                            
                            Spacer(minLength:0)
                        }
                        
                        
                        }
                }.padding(.horizontal,10)
            }.onAppear{
                reComEvent()
            }
        }
    }
    

    func reComEvent() {
        db.collection("Users").document(user?.uid ?? "").addSnapshotListener { [self] (document, error) in
            guard let docs = document else{
                print("num")
                return
            }
            if docs.exists {
                self.categoryUserSel = docs.data()?["categoryEvent"] as! [String]
                print(categoryUserSel.count)
            }
             else {
                print("Document does not exist ไม่มีข้อมูล")
            }
        }
    }
    
    
}





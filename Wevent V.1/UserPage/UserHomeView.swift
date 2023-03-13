//
//  UserHomeView.swift
//  Wevent V.1
//
//  Created by Palm on 3/5/2564 BE.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn
import SwiftUIRefresh
import RefreshableScrollView


struct UserHomeView: View {
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()

    @StateObject var eventDataHave = EventViewHaveLimit()
    
    
    @State var url = ""
    @State private var isShowing = false
    @State private var refresh = false
    @State var showNotification = false
    
    @State var getAllEvent = false
    
    @State var numEvent = 0
    
 
    var body: some View {

            VStack {
               
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10.0) {
                            Text("Wevent")
                                .font(Font.custom("Bebas Neue", size: 40))
                        }
                        
                        //.foregroundColor(.black)
                        Spacer(minLength:0)
                        
                        VStack(alignment: .trailing, spacing: 10.0) {
                            Image(systemName: "bell.fill")
                                .font(Font.custom("Bebas Neue", size: 30))
                        }
                        .onTapGesture {
                            self.showNotification.toggle()
                        }
                        .fullScreenCover(isPresented: $showNotification){
                            NotificationView(showNotification: self.$showNotification)
                        }
                        //.foregroundColor(.black)
                    }
                    
                }.padding(.horizontal, 10)
                .padding(.bottom,1)
                
                
                VStack{
                    RefreshableScrollView(refreshing: $refresh, action: {
                        // add your code here
                        // remmber to set the refresh to false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.refresh = false
                            eventDataHave.getAllEvents()
                        }
                    }) {
                        ProfileCardUser()
                            .environmentObject(UserModel())
                            .padding(.vertical, 5)
                        HStack {
                            Text("อีเว้นท์")
                                .font(.body)
                            Spacer(minLength:0)
                            Text("ที่เข้าร่วมล่าสุด")
                                .font(.body)
                        }
                        .padding(.horizontal, 10)

                            ForEach(eventDataHave.eventsHaveLimit){ event in
                                EventCard(events: event)
                            }
                        
                        if eventDataHave.eventsHaveLimit.count >= 5 {
                            HStack {
                                Spacer()
                                VStack{
                                    Text("แสดงอีเว้นท์ทั้งหมด")
                                        .foregroundColor(.white)
                                }.padding(10)
                                .background(Color.gray)
                                .cornerRadius(8)
                                //.clipShape(Capsule())
                                .padding(.bottom, 10)
                                .onTapGesture {
                                    self.getAllEvent.toggle()
                                }
                                .fullScreenCover(isPresented: $getAllEvent){
                                    AllEventJoinView(getAllEvent: self.$getAllEvent)
                                }
                                Spacer()
                            }.padding(.horizontal, 10)
                        }
                    }
                }.padding(.horizontal,10)
                
                
            
   
            }

    }
    
}





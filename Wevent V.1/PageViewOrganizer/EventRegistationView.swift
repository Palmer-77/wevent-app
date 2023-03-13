//
//  EventRegistationView.swift
//  Wevent V.1
//
//  Created by You Know on 3/6/2564 BE.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct EventRegistationView: View {
    
    @Binding var getEventRegistationView:Bool
    @State var getRegisterEvent = false
    @State var showSearch = false
    @State var showSearch2 = false
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    
    var eventDetail : EventModel
    @StateObject var signMember = UserViewRegister()
    
    var body: some View {
        ScrollView{
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text("Event Registation")
                            .font(Font.custom("Bebas Neue", size: 40))
                    }
                    //.foregroundColor(.black)
                    Spacer(minLength:0)
                    VStack{
                        Button(action: {
                            self.getEventRegistationView.toggle()
                        }){
                            Image(systemName: "xmark.circle")
                                .font(Font.custom("Bebas Neue", size: 30))
                        }
                    }
                }

            }.padding(.horizontal, 10)
            HStack{
                VStack{
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(Font.custom("Bebas Neue", size: 60))
                        .foregroundColor(.black)
                }.padding(.vertical)
                .padding(.horizontal,20)
                VStack{
                    HStack{
                        Text("เช็คชื่อเข้างาน")
                            .font(.body)
                            .bold()
                        Spacer()
                    }
                    HStack{
                        Text("การลงทะเบียนเข้างานด้วย QR Code")
                            .font(.caption)
                            .bold()
                            .opacity(0.5)
                        Spacer()
                    }
                }.padding(.vertical,10)
                 .foregroundColor(Color.black)
            }
            .background(Color.newECECEC)
            .cornerRadius(10)
            .padding(8)
            .padding(.horizontal,5)
            .onTapGesture {
                self.getRegisterEvent.toggle()
            }
            .fullScreenCover(isPresented: $getRegisterEvent ){
                RegisterEventView(getRegisterEvent: $getRegisterEvent, eventDetail: eventDetail)
            }
            
            
            HStack{
                VStack{
                    Image(systemName: "person.crop.circle")
                        .font(Font.custom("Bebas Neue", size: 60))
                        .foregroundColor(.black)
                }.padding(.vertical)
                .padding(.horizontal,20)
                VStack{
                    HStack{
                        Text("ตรวจสอบผู้สมัครเข้าร่วมอีเว้นท์")
                            .font(.body)
                            .bold()
                        Spacer()
                    }
                    HStack{
                        Text("การลงทะเบียนเข้างานด้วย QR Code")
                            .font(.caption)
                            .bold()
                            .opacity(0.5)
                        Spacer()
                    }
                }.padding(.vertical,10)
                 .foregroundColor(Color.black)
            }
            .background(Color.newECECEC)
            .cornerRadius(10)
            .padding(8)
            .padding(.horizontal,5)
            .onTapGesture {
                self.showSearch2.toggle()
            }
            .fullScreenCover(isPresented: $showSearch2 ){
                ShowLikeEventView(showSearch2: self.$showSearch2, eventID: eventDetail.id)
            }
            
            
            HStack{
                VStack{
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .font(Font.custom("Bebas Neue", size: 60))
                        .foregroundColor(.black)
                }.padding(.vertical)
                .padding(.horizontal,20)
                VStack{
                    HStack{
                        Text("ตรวจสอบผู้ลงทะเบียนเข้าร่วมอีเว้น")
                            .font(.body)
                            .bold()
                        Spacer()
                    }
                    HStack{
                        Text("การลงทะเบียนเข้างานด้วย QR Code")
                            .font(.caption)
                            .bold()
                            .opacity(0.5)
                        Spacer()
                    }
                }.padding(.vertical,10)
                 .foregroundColor(Color.black)
            }
            .background(Color.newECECEC)
            .cornerRadius(10)
            .padding(8)
            .padding(.horizontal,5)
            .onTapGesture {
                self.showSearch.toggle()
            }
            .fullScreenCover(isPresented: $showSearch ){
                ShowRegisterEventView(showSearch: self.$showSearch, signMember: signMember.signMember, eventID: eventDetail.id)
            }
            
            Spacer()
        }
    }
}


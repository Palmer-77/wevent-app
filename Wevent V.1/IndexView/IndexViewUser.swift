//
//  IndexViewUser.swift
//  Wevent V.1
//
//  Created by Palm on 2/5/2564 BE.
//

import SwiftUI
import Firebase
import GoogleSignIn
import CoreImage.CIFilterBuiltins

struct UserIndexView: View {
    //@State private var isShowTab = false
    @State private var selection = 0
    
    @AppStorage("log_organizer") var log_organizer = false
    @AppStorage("log_user") var log_user = false
    @AppStorage("log_switch") var log_switch = false
    @AppStorage("organizer") var organizer = false

    
    @AppStorage("log_status") var log_Status = false
    @AppStorage("log_data") var log_data = false
    @AppStorage("log_login") var log_login = false
    @AppStorage("currentPage") var currentPage = 1
    let user = Auth.auth().currentUser
    
    let db = Firestore.firestore()
    
    let context = CIContext()
    
    @State var editIntroShow = false
    @State var showFeedback = false

    @State var selectFFB : [String] = []
    


    var body: some View {
        
        VStack(alignment: .center){
                TabView(selection: $selection) {
                    UserHomeView()
                        .tag(0)
                    UserSearchView()
                        .tag(1)
                    UserFeedView()
                        .tag(2)
                    UserProfileView()
                        .environmentObject(UserModel())
                        .tag(3)

                    VStack(alignment: .center) {
                        HStack {
                            VStack(alignment: .leading, spacing: 10.0) {
                                Text("Setting")
                                    .font(Font.custom("Bebas Neue", size: 40))
                            }
                            //.foregroundColor(.black)
                            
                            Spacer(minLength: 0)
                            
                        }
                        .padding(.horizontal, 10)
                        
                        if self.organizer {
                        VStack {
                            Button(action: {
                                self.log_user = false
                                self.log_switch = true
                                self.log_organizer = false
                            }) {

                                Text("Switch Mode")
                                    .foregroundColor(.black)
                            }
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .background(Color.newECECEC)
                            .cornerRadius(8)
                            //.clipShape(Capsule())
                            .padding(.bottom, 10)
                        }.padding(.horizontal, 10)
                    }
                        
                        VStack {
                            Button(action: {
                                self.editIntroShow.toggle()
                            }) {

                                Text("แก้ไขสิ่งที่สนใจ")
                                    .foregroundColor(.black)
                            }
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .background(Color.newECECEC)
                            .cornerRadius(8)
                            //.clipShape(Capsule())
                            .padding(.bottom, 10)
                        }.fullScreenCover(isPresented: $editIntroShow){
                            EditIntroView(editIntroShow: self.$editIntroShow)
                        }
                        .padding(.horizontal, 10)
                        
                        VStack {
                            Button(action: {
                                self.showFeedback.toggle()
                            }) {
                                
                                Text("ส่งข้อเสนอแนะ")
                                    .foregroundColor(.black)
                            }
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .background(Color.newECECEC)
                            .cornerRadius(8)
                            //.clipShape(Capsule())
                            .padding(.bottom, 10)
                        }.padding(.horizontal, 10)
                        .fullScreenCover(isPresented: $showFeedback){
                            FeedbackView(showFeedback: self.$showFeedback)
                        }
                        
                        VStack {
                            Button(action: {
                                
                                try! Auth.auth().signOut()
                                GIDSignIn.sharedInstance()?.signOut()
                                UserDefaults.standard.set(false, forKey: "log_status")
                                UserDefaults.standard.set(true, forKey: "log_data")
                                UserDefaults.standard.set(false, forKey: "log_login")
                                UserDefaults.standard.set(1, forKey: "currentPage")
                                self.log_user = false
                                self.log_switch = false
                                self.log_organizer = false

                            }) {
                            
                            Text("ออกจากระบบ")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(Color.red)
                        .cornerRadius(8)
                        //.clipShape(Capsule())
                        .padding(.bottom, 20)
                        }.padding(.horizontal, 10)
                        
                        Spacer(minLength: 0)
                    }
                        .tag(4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            
                //Divider()
                TabBarViewUser(selectionUser: $selection)
            }
            
                
        
    }
    

}




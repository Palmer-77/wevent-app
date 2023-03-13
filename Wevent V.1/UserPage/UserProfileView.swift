//
//  UserProfilrView.swift
//  Wevent V.1
//
//  Created by Palm on 3/5/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn
import SDWebImageSwiftUI

struct UserProfileView: View {
    var storageManager = StorageManager()
    @State private var image = UIImage()
    @State private var showSheet = false
    @EnvironmentObject var userModel : UserModel
    @State var showQRcode = false
    @State var getEdit = false
    let user = Auth.auth().currentUser
    @State var url = ""
    let storageRef = Storage.storage().reference()
    
    @State var alertSendLink = false
    
    
    
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Profile")
                        .font(Font.custom("Bebas Neue", size: 40))
                }
                //.foregroundColor(.black)
                Spacer(minLength: 0)
                VStack(alignment: .trailing, spacing: 0) {
                    Button(action: {
                        self.getEdit.toggle()
                        
                    }) {
                        
                        Image(systemName: "square.and.pencil")
                            .font(Font.custom("Bebas Neue", size: 30))
                        
                        
                    }
                }.fullScreenCover(isPresented: $getEdit){
                    EditProfileView(getEdit: self.$getEdit)
                }

            }.padding(.horizontal, 10)
                
            
            
            VStack{
                VStack {
                    if url != "" {
                        VStack {
                            Text("User")
                                .font(Font.custom("Bebas Neue", size: 30))
                            AnimatedImage(url: URL(string: url)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.blue, lineWidth: 5))
                            .frame(width: 200, height: 200, alignment: .center)
                                .padding(10)
                            
                        }

                    }
                    else {
                        Image("Wevent-2")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 5))
                        .frame(width: 200, height: 200, alignment: .center)
                            .padding(10)
                    }
                    
                    
                    //.padding()
                }
                .onAppear {
                    let storage = Storage.storage().reference()
                    storage.child("Users/Profile/ProfileID-\(user!.uid)").downloadURL{(url,err) in
                        if err != nil {
                            print((err?.localizedDescription)!)
                            return
                        }
                        self.url = "\(url!)"
                    }
                }
                
                
                VStack {
                    VStack{
                        if user!.isEmailVerified{
                            HStack{
                                Image(systemName: "person.crop.circle.fill.badge.checkmark")
                                Text("ยืนยันตัวตนเรียบร้อย")
                                    .bold()
                            }.font(.body)
                            .foregroundColor(Color.newGreenK)
                            .padding(10)
                        }
                        else {
                            HStack{
                                Image(systemName: "person.crop.circle.fill.badge.exclamationmark")
                                Text("คลิกเพื่อยืนยัน")
                                    .bold()
                            }.font(.body)
                            .foregroundColor(Color.red)
                            .padding(10)
                            .onTapGesture {
                                user?.sendEmailVerification { (error) in
                                    if let error = error {
                                        print("error")
                                    }
                                    else {
                                        self.alertSendLink.toggle()
                                    }
                                }
                            }
                        }
                    }.alert(isPresented: $alertSendLink) {
                        Alert(title: Text("แจ้งเตือน"), message: Text("ส่งลิ้งยืนยันไปที่จดหมายอีเมลเรียบร้อย"), dismissButton: .default( Text("ตกลง"))
                        )
                    }

                Text("\(userModel.name) \(userModel.lastname)")
                    .font(Font.custom("Bebas Neue", size: 25))
                Text("\(user?.email ?? "")")
                    .font(Font.custom("Bebas Neue", size: 25))
                Button(action: {
                    self.showQRcode.toggle()
                }) {
                    HStack {
                        Image(systemName: "qrcode")
                        Text("QR-Code")
    
                    }.font(Font.custom("Bebas Neue", size: 25))
                    
                }
            }.fullScreenCover(isPresented: $showQRcode) {
                QRCodeView(showQRcode: self.$showQRcode)
            }
            .padding(.horizontal, 20)
                

                
            }
            Spacer(minLength: 0)
            
            
        }
        //.background(Color.black.opacity(0.05).ignoresSafeArea(.all,edges: .all))
    }
    
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .environmentObject(UserModel())
    }
}

//
//  FeedbackView.swift
//  Wevent V.1
//
//  Created by You Know on 10/6/2564 BE.
//

import SwiftUI
import MessageUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct FeedbackView: View {
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    @State var showMailSheet = false
    
    @Binding var showFeedback:Bool
    
    @State var comment = ""
    @State var show = "ระบุรายละเอียดเพิ่มเติม"
    @State var title = "ส่งคำขอ เรื่อง"
    @State var email = "porndittha77@gmail.com"
    
    @State var category = "ผู้เข้าร่วม"
    @State var feedBack = "คำถามทั่วไป"
    
    @State var name = ""
    @State var lastName = ""
    @State var tel = ""
    
    var body: some View {
        ScrollView{
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text("Feedback")
                            .font(Font.custom("Bebas Neue", size: 40))
                    }
                    
                    //.foregroundColor(.black)
                    Spacer(minLength:0)
                    
                    VStack{
                        Button(action: {
                            self.showFeedback.toggle()
                        }){
                            Image(systemName: "xmark.circle")
                                .font(Font.custom("Bebas Neue", size: 30))
                        }
                    }
                }
                
            }.padding(.horizontal, 10)
            
            VStack(alignment: .center){
                    Text("ส่งข้อเสนอแนะ")
                        .font(.title)
                        .bold()
                    Text("หากคุณมีคำถามหรือคำแนะนำอื่นๆ สามารถแจ้งเราได้ที่นี่\nและเราจะรีบติดต่อกลับหาคุณโดยเร็ว")
                        .multilineTextAlignment(.center)
                        .font(.footnote)
                        .padding(.bottom,8)
                VStack{
                    HStack{
                        Text("คุณคือผู้เข้าร่วมหรือผู้จัดงาน")
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    HStack(spacing: 15){
                        
                        Image(systemName: "person.fill.questionmark")
                            .foregroundColor(Color.black)
                        Picker("", selection: $category) {
                                    ForEach(["ผู้เข้าร่วม","ผู้จัดงาน"], id: \.self) {
                                        Text("\($0)")
                                    }
                        }.pickerStyle(SegmentedPickerStyle())
                        .foregroundColor(Color.black)
                    }.padding(.vertical, 10)
                    
                }.padding(.bottom,10)
                VStack{
                    HStack{
                        Text("หัวข้อที่ถาม")
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    HStack{
                        Menu {
                            Button {
                                self.feedBack = "คำถามทั่วไป"
                            } label: {
                                Text("คำถามทั่วไป")
                                Image(systemName: "arrow.down.right.circle")
                            }
                            Button {
                                self.feedBack = "ขอสิทธิ์เป็นผู้จัดงาน"
                            } label: {
                                Text("ขอสิทธิ์เป็นผู้จัดงาน")
                                Image(systemName: "arrow.up.and.down.circle")
                            }
                            Button {
                                self.feedBack = "ปัญหาเกี่ยวกับแอปพลิเคชัน"
                            } label: {
                                Text("ปัญหาเกี่ยวกับแอปพลิเคชัน")
                                Image(systemName: "arrow.up.and.down.circle")
                            }
                            Button {
                                self.feedBack = "บัญชีและความปลอดภัย"
                            } label: {
                                Text("บัญชีและความปลอดภัย")
                                Image(systemName: "arrow.up.and.down.circle")
                            }
                        } label: {
                             Text(feedBack)
                             Image(systemName: "tag.circle")
                        }
                        Spacer()
                    }.padding(.horizontal,10)
                    
                }.padding(.bottom,10)
                
                VStack{
                    HStack{
                        Text("ข้อความ")
                            .font(.title3)
                            .bold()
                        Spacer()
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
                            
                        }.padding(5)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue,lineWidth: 1)
                        )
                    }
                }.padding(.bottom,10)
                
            }.padding(.horizontal,10)
            .padding(.bottom,10)
        
            Button(action: {
                        self.showMailSheet.toggle()
                    }) {
                        Text("ส่ง")
                    }
        }.onAppear{
            getUser()
        }
                .sheet(isPresented: self.$showMailSheet) {
                    MailView(isShowing: self.$showMailSheet,
                             resultHandler: {
                                value in
                                switch value {
                                case .success(let result):
                                    switch result {
                                    case .cancelled:
                                        print("cancelled")
                                    case .failed:
                                        print("failed")
                                    case .saved:
                                        print("saved")
                                    default:
                                        print("sent")
                                    }
                                case .failure(let error):
                                    print("error: \(error.localizedDescription)")
                                }
                    },
                             subject: "\(title) \(feedBack)",
                             toRecipients: ["wevent.contact61@gmail.com"],
                             ccRecipients: [""],
                             bccRecipients: [""],
                             messageBody: "\(title) \(feedBack)\n จากคุณ: \(name) \(lastName) - \(category) \n ไอดี: \(user?.uid ?? "") \n อีเมล: \(user?.email ?? "") \n เบอร์โทรศัพท์: \(tel) \n ข้อความ: \(comment)",
                             isHtml: false)
                    .safe()


            
            Spacer()
        }
    }
    
    func getUser() {
        db.collection("Users").document("\(user?.uid ?? "")").getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                                if let data = data {
                                    print("date", data)
                                    self.lastName = "\(data["lastName"] as? String ?? "")"
                                    self.name = "\(data["name"] as? String ?? "")"
                                    self.tel = "\(data["tel"] as? String ?? "")"
                                }
            } else {
                print("Document does not exist ไม่มีข้อมูล")
            }
        }
    }
}


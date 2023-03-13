//
//  Login.swift
//  Wevent V.Demo2
//
//  Created by Palm on 21/4/2564 BE.
//

import SwiftUI
import GoogleSignIn
import AuthenticationServices
import Firebase

struct Login: View {
    
    @AppStorage("log_organizer") var log_organizer = false
    @AppStorage("organizer") var organizer = false
    @AppStorage("log_user") var log_user = false
    @AppStorage("log_switch") var log_switch = false
    @AppStorage("log_status") var log_Status = false
    @AppStorage("log_data") var log_data = false
    @State var alert = false
    @State var alert2 = false
    @State var alertMsg = ""
    
    @State private var email = ""
    @State private var password = ""
    @State private var con_password = ""
    @State private var showPassword: Bool = false
    @State private var showRegis: Bool = false
    @State private var showAlert: Bool = false
    
    let db = Firestore.firestore()
    
    var body: some View {
            ZStack{
                
                Image("space")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width)
                    .overlay(Color.black.opacity(0.35))
                    .ignoresSafeArea()
                
                ScrollView{
                    
                    Text("Welcome")
                        .font(Font.custom("Bebas Neue", size: 50))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    
                    Spacer()
                    Spacer()
                        VStack{
                            
                            VStack{
                                if showRegis {
                                    Text("Register")
                                        .font(Font.custom("Bebas Neue", size: 30))
                                }
                                else{
                                    Text("login")
                                        .font(Font.custom("Bebas Neue", size: 30))
                                }
                                
                            }
                            VStack{
                                HStack(alignment: .center){
                                    Image(systemName: "person.fill")
                                    TextField("email",text: $email)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.horizontal,20)
                                .font(.body)
                                
                            }.padding(.bottom, 10)
                            .shadow(radius: 2.5)
                            VStack{

                                HStack(alignment: .center) {
                                    Image(systemName: "key.fill")
                                    if showPassword {
                                        TextField("Password",text: $password)
                                        Button(action: {
                                            self.showPassword.toggle()}){
                                            Image(systemName: "eye.slash")
                                        }
                                    } else {
                                        SecureField("Password", text: $password)
                                        Button(action: {
                                            self.showPassword.toggle()}){
                                            Image(systemName: "eye")
                                        }
                                    }
                                    
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.horizontal,20)
                                .font(.body)
                                
                            }
                            .shadow(radius: 2.5)
                            .padding(.bottom, 15)
                            
                            if showRegis {
                                VStack{

                                    HStack(alignment: .center) {
                                        Image(systemName: "key.fill")
                                        if showPassword {
                                            TextField("Confirn - Password",text: $con_password)
                                            Button(action: {
                                                self.showPassword.toggle()}){
                                                Image(systemName: "eye.slash")
                                            }
                                        } else {
                                            SecureField("Confirn - Password", text: $con_password)
                                            Button(action: {
                                                self.showPassword.toggle()}){
                                                Image(systemName: "eye")
                                            }
                                        }
                                        
                                    }.padding()
                                    .frame(height: 40, alignment: .center)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal,20)
                                    .font(.body)
                                    
                                }
                                .shadow(radius: 2.5)
                                .padding(.bottom, 15)
                            }
                            if showRegis {
                                //Button
                                HStack{
                                    VStack{
                                        Button(action: {
                                            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                                                if error != nil{
                                                    self.alert2 = true
                                                    self.alertMsg = "ลงทะเบียนไม่สำเร็จ คุณอาจกรอก email ผิด"
                                                }
                                                else{
                                                    self.alert2 = true
                                                    self.alertMsg = "ลงทะเบียนเสร็จสิ้น"
                                                    self.showRegis.toggle()
                                                }
                                            }
                                        }) {
                                            HStack{
                                                Image(systemName: "mail.fill")
                                                Text("Register")
                                                    
                                            }.foregroundColor(.white)
                                            .font(Font.custom("Bebas Neue", size: 24))
                                            
                                        }.padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width-250,height: 50)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                        .padding(.bottom, 5)
                                        .alert(isPresented: self.$alert2) {
                                                    Alert(title: Text("แจ้งเตือน"), message: Text(alertMsg), dismissButton: .default(Text("ตกลง")))
                                                }
                                    }
                                    VStack{
                                        Button(action: {
                                            self.showRegis.toggle()
                                            email = ""
                                            password = ""
                                        }) {
                                            
                                            HStack{
                                                //Image(systemName: "mail.fill")
                                                Text("cancel")
                                                    
                                            }.foregroundColor(.white)
                                            .font(Font.custom("Bebas Neue", size: 24))
                                            
                                        }.padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width - 250,height: 50)
                                        .background(Color.red)
                                        .cornerRadius(10)
                                        .padding(.bottom, 5)
                                    }
                                }

                            }
                            else {
                                VStack{
                                    Button(action: {
                                        
                                        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                                            if err != nil{
                                                self.alertMsg = err!.localizedDescription
                                                self.alert.toggle()
                                                password = ""
                                                return
                                            }
                                            else {
                                                let user = Auth.auth().currentUser
                                                
                                                db.collection("Users").document(user?.uid ?? "")
                                                    .addSnapshotListener { documentSnapshot, error in
                                                          guard let document = documentSnapshot else {
                                                            print("Error fetching document: \(error!)")
                                                            return
                                                          }
                                                          guard error == nil else {
                                                            print("error", error ?? "")
                                                            //self.log_data = true
                                                            return
                                                          }
                                                          if document.exists {
                                                            print("Have data")
                                                            self.log_Status = true
                                                            self.log_data = false
                                                            self.log_organizer = (document["organizer"]! as! Int == 1)
                                                            self.log_user = (document["user"]! as! Int == 1)
                                                            self.organizer = (document["organizer"]! as! Int == 1)
                                                            if self.log_organizer == true && self.log_user == true {
                                                                self.log_switch = true
                                                            }
                                                            
                                                          }
                                                          else {
                                                            print("No data")
                                                            self.log_Status = true
                                                            self.log_data = true
                                                          }
                                                        }
                                            }
                                            
                                           
                                            
                                        }
                                    }) {
                                        Text("Join")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .font(Font.custom("Bebas Neue", size: 24))
                                    }.padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width-75,height: 50)
                                    .background(Color.red)
                                    .cornerRadius(10)
                                    .padding(.bottom, 5)
                                    .alert(isPresented: self.$alert) {
                                                Alert(title: Text("แจ้งเตือน"), message: Text("email หรือ รหัสผ่าน ของคุณผิด"), dismissButton: .default(Text("ตกลง")))
                                            }
                                }
                            }
                            
                            
                            
                            HStack{
                                VStack{
                                    Divider()
                                }
                                Text("or")
                                VStack{
                                    Divider()
                                }
                            }.padding(.horizontal, 20)
                            .font(Font.custom("Bebas Neue", size: 20))
                            
                            VStack{
                                Button(action: {

                                        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
                                        
                                        GIDSignIn.sharedInstance()?.signIn()

                                }) {
                                    
                                    HStack(spacing: 30){
                                        
                                        // Changing Text When Last Screen Appears..
                                        
                                            
                                            Image("google")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(.white)
                                            .frame(width: 25, height: 25)
                                        
                                        
                                        Text("Google")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .font(Font.custom("Bebas Neue", size: 24))
                                        
                                    }
                                    .frame(width: UIScreen.main.bounds.width - 75,height: 50)
                                    .background(Color.red)
                                    .cornerRadius(10)
                                    .padding(.bottom, 5)
                                }
                            }
                            //register
                            VStack{
                                if showRegis {
                                    
                                }
                                else{
                                    VStack{
                                        Button(action: {
                                            self.showRegis.toggle()
                                        }) {
                                            
                                            HStack{
                                                Image(systemName: "mail.fill")
                                                Text("Register")
                                                    
                                            }.foregroundColor(.white)
                                            .font(Font.custom("Bebas Neue", size: 24))
                                            
                                        }.padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width - 75,height: 50)
                                        .background(Color.new413C69)
                                        .cornerRadius(10)
                                        .padding(.bottom, 5)
                                    }
                                }
                            }//end
                            
                        }
                        .padding(.vertical)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal,20)
                    
                    
                    
                    Spacer()
                }
            }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

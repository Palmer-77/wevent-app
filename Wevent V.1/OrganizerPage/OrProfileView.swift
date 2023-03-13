//
//  ProfileView.swift
//  Wevent version 0.0.1
//
//  Created by Palm on 24/3/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn
import SDWebImageSwiftUI

struct OrProfileView: View {
    var storageManager = StorageManager()
    @State private var image = UIImage()
    @State private var showSheet = false
    @EnvironmentObject var userModel : UserModel
    @State var showQRcode = false
    @State var getEdit = false
    let user = Auth.auth().currentUser
    @State var url = ""
    let storageRef = Storage.storage().reference()
    
//    init() {
//        setImg()
//    }
    
    
    
    
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
                            Text("Organizer")
                                .font(Font.custom("Bebas Neue", size: 30))
                            AnimatedImage(url: URL(string: url)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                            .frame(width: 200, height: 200, alignment: .center)
                            
                            
                        }

                    }
                    else {
                        Loader()
                    }
                    
                    
                    //.padding()
                }.onAppear {
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
                Text("\(userModel.name) \(userModel.lastname)")
                    .font(Font.custom("Bebas Neue", size: 25))
                Text("\(user?.email ?? "")")
                    .font(Font.custom("Bebas Neue", size: 25))
            }
            .padding(.horizontal, 20)
                

                
            }
            Spacer(minLength: 0)
            
            
        }
        //.background(Color.black.opacity(0.05).ignoresSafeArea(.all,edges: .all))
    }
    
}

struct Loader : UIViewRepresentable {
    
    
    
    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView {

        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()

        return indicator
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Loader>) {

    }
    
}

struct OrProfileView_Previews: PreviewProvider {
    static var previews: some View {
        OrProfileView()
            .environmentObject(UserModel())
    }
}

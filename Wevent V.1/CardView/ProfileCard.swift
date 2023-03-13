//
//  ProfileCard.swift
//  Wevent V.1
//
//  Created by Palm on 21/4/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SDWebImageSwiftUI

struct ProfileCard: View {
    @EnvironmentObject var userModel : UserModel
    let user = Auth.auth().currentUser
    @State var url = ""
    var image = "Wevent"
    
    var body: some View {
        HStack(alignment: .top) {
            
            VStack(alignment: .leading) {
                Text("Organizer ")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    
                
                Text("Hello, \(userModel.name)")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundColor(.white)
                
                Text("\(userModel.email)")
                    .font(.system(size: 15, weight: .bold, design: .default))
                    .foregroundColor(.white)
            }.padding(20)
            Spacer()
            Spacer()
            VStack {
                if url != "" {
                    VStack {
                        AnimatedImage(url: URL(string: url)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                        .frame(width: 100, height: 100)
                        
                    }.padding()

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
            
        }
        //.frame(maxWidth: .infinity, alignment: .center)
        .background(Color.new413C69)
        .modifier(CardModifier())
        //.padding(.horizontal)
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(10)
    }
    
}

struct ProfileCard_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCard()
            .environmentObject(UserModel())
    }
}

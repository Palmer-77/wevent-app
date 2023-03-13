//
//  ListCardSignUser.swift
//  Wevent V.1
//
//  Created by You Know on 10/6/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn
import SDWebImageSwiftUI

struct ListCardSignUser: View {
    
    @State var signMember:SignMemberModel
    
    @State var url = ""
    
    var body: some View {
        HStack{
            
            VStack {
                if url != "" {
                    VStack {
                        AnimatedImage(url: URL(string: url)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        .frame(width: 50, height: 50, alignment: .center)
                            
                        
                    }

                }
                else {
                    Image("Wevent-2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    .frame(width: 50, height: 50, alignment: .center)
                        
                }
                
                
                //.padding()
            }
            .onAppear {
                let storage = Storage.storage().reference()
                storage.child("Users/Profile/ProfileID-\(signMember.userID)").downloadURL{(url,err) in
                    if err != nil {
                        print((err?.localizedDescription)!)
                        return
                    }
                    self.url = "\(url!)"
                }
            }
            
            
            VStack{
                HStack{
                    Text(signMember.name)
                        .bold()
                    Text(signMember.lastName)
                        .bold()
                    Spacer()
                }
                HStack{
                    Text(signMember.email)
                        .font(.caption)
                    Spacer()
                }
            }
            Spacer()
            Text(signMember.date)
                .font(.caption2)
        }
    }
}



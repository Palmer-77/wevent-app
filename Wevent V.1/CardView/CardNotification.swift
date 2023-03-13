//
//  CardNotification.swift
//  Wevent V.1
//
//  Created by You Know on 21/6/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore


struct CardNotification: View {
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    @State var notification :  NotificationModel
    
    var body: some View {
        HStack{
            VStack{
                Image("Wevent-2")
                    .frame(width: 120, height: 80)
                    .cornerRadius(5)
            }.padding(5)
            
            VStack(alignment: .leading){
                Text(notification.title)
                    .font(.callout)
                    .bold()
                    .lineLimit(3)
                Text(notification.date)
                    .font(.caption)
            }.padding(10)
            
            VStack{
                Image(systemName: "trash.circle")
                    .font(Font.custom("Bebas Neue", size: 30))
            }.padding(2)
            .onTapGesture {
                db.collection("Notification").document(notification.id).updateData([
                    "userID" : FieldValue.arrayRemove([user?.uid as Any])
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            }
            
            Spacer()
        }.padding(.vertical,1)
        .background(ZStack{
            
            Image("Wevent-2")
                .clipped()
                .scaledToFill()
                .blur(radius: 5)
                .opacity(0.25)
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black,lineWidth: 1)
        })
        .cornerRadius(10)
        .padding(.horizontal,10)
        
        
        
    }
    
    
}


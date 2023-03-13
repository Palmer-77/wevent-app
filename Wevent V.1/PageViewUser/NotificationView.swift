//
//  NotificationView.swift
//  Wevent V.1
//
//  Created by You Know on 10/6/2564 BE.
//

import SwiftUI
import RefreshableScrollView

struct NotificationView: View {
    @Binding var showNotification:Bool
    @State private var isShowing = false
    @State var refresh = false
    
    @StateObject var notification = NotificationViewModel()
    
    var body: some View {
        VStack{
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text("Notification")
                            .font(Font.custom("Bebas Neue", size: 40))
                    }
                    
                    //.foregroundColor(.black)
                    Spacer(minLength:0)
                    
                    VStack{
                        Button(action: {
                            self.showNotification.toggle()
                        }){
                            Image(systemName: "xmark.circle")
                                .font(Font.custom("Bebas Neue", size: 30))
                        }
                    }
                }
                
            }.padding(.horizontal, 10)
            .padding(.bottom,1)
            VStack{
                RefreshableScrollView(refreshing: $refresh, action: {
                    // add your code here
                    // remmber to set the refresh to false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.refresh = false
                        notification.getAllEvents()
                    }
                }) {
                    ForEach(notification.notification){ noti in
                            CardNotification(notification: noti)
                    }
                    
                }
            }.padding(.horizontal,5)
            
                
            Spacer()
            
        }
    }
    
    
}


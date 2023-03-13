//
//  Home.swift
//  Wevent version 0.0.1
//
//  Created by Palm on 24/3/2564 BE.
//

import SwiftUI

import RefreshableScrollView

struct OrHomeView: View{
    
    @StateObject var eventDataEdit = EventViewEdit()
    @State private var refresh = false
    
    @State var url = ""
    @State private var isShowing = false
    
    var body: some View {

        VStack(alignment: .center){
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10.0) {
                            Text("Wevent")
                                .font(Font.custom("Bebas Neue", size: 40))
                        }
                        
                        //.foregroundColor(.black)
                        Spacer(minLength:0)
                        
                        //.foregroundColor(.black)
                        VStack(alignment: .trailing, spacing: 10.0) {
                            Image(systemName: "bell.fill")
                                .font(Font.custom("Bebas Neue", size: 30))
                        }
                        //.foregroundColor(.black)
                    }
                    
                }.padding(.horizontal, 10)
                .padding(.bottom, 2)
            
            
            
            VStack{
                            RefreshableScrollView(refreshing: $refresh, action: {
                                // add your code here
                                // remmber to set the refresh to false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self.refresh = false
                                    eventDataEdit.getAllEvents()
                                }
                            }) {
                                ProfileCard()
                                    .environmentObject(UserModel())
                            
                            HStack {
                                Text("อีเว้นท์")
                                    .font(.body)
                                Spacer(minLength:0)
                                Text("ของคุณ")
                                    .font(.caption)
                            }.padding(.horizontal, 10)

                            ScrollView {
                                ForEach(eventDataEdit.eventsEdit){ event in
                                    EventCardEdit(events: event)
                                }
                            }
                        }
                        }.padding(.horizontal,10)
        }
    }
}






struct OrHomeView_Previews: PreviewProvider {
    static var previews: some View {
        OrHomeView()
            
    }
}

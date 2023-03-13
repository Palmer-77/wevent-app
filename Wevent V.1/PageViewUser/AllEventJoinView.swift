//
//  AllEventJoinView.swift
//  Wevent V.1
//
//  Created by You Know on 21/6/2564 BE.
//

import SwiftUI
import RefreshableScrollView

struct AllEventJoinView: View {
    
    @StateObject var eventDataHave = EventViewHave()
    @State private var isShowing = false
    @State private var refresh = false
    
    @Binding var getAllEvent:Bool
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text("All Events")
                            .font(Font.custom("Bebas Neue", size: 40))
                    }
                    
                    //.foregroundColor(.black)
                    Spacer(minLength:0)
                    
                    VStack{
                            Image(systemName: "xmark.circle")
                                .font(Font.custom("Bebas Neue", size: 30))
                    }.onTapGesture {
                        self.getAllEvent.toggle()
                    }
                } .padding(.vertical, 1)
            }.padding(.horizontal, 10)
            .padding(.bottom,1)
            VStack{
                RefreshableScrollView(refreshing: $refresh, action: {
                    // add your code here
                    // remmber to set the refresh to false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.refresh = false
                        eventDataHave.getAllEvents()
                    }
                }) {
                    HStack {
                        Text("อีเว้นท์")
                            .font(.body)
                        Spacer(minLength:0)
                        Text("\(eventDataHave.eventsHave.count) ที่เข้าร่วม")
                            .font(.body)
                    }
                    .padding(.horizontal, 10)

                        ForEach(eventDataHave.eventsHave){ event in
                            EventCard(events: event)
                        }
                }
            }.padding(.horizontal,10)
            
            Spacer()
        }
    }
}


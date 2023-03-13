//
//  SearchView.swift
//  Wevent version 0.0.1
//
//  Created by Palm on 24/3/2564 BE.
//

import SwiftUI
import RefreshableScrollView

struct OrManageView: View {
    @State var showScan = false
    @StateObject var eventDataEdit = EventViewEdit()
    @State private var refresh = false
    
    @State var url = ""
    @State private var isShowing = false
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Manage Event")
                        .font(Font.custom("Bebas Neue", size: 40))
                }
                Spacer(minLength: 0)
                
            }
            .padding(.horizontal, 10)
            HStack {
                Text("อีเว้นท์")
                    .font(.body)
                Spacer(minLength:0)
                Text("ของคุณ")
                    .font(.caption)
            }.padding(.horizontal, 10)
            
            
            VStack{
                RefreshableScrollView(refreshing: $refresh, action: {
                                // add your code here
                                // remmber to set the refresh to false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    self.refresh = false
                                    eventDataEdit.getAllEvents()
                                }
                            }) {

                    ForEach(eventDataEdit.eventsEdit){ event in
                        EventCardEdit(events: event)
                    }
                            }
            }.padding(.horizontal,10)
            Spacer(minLength: 0)
            
            
        }
        
        //.background(Color.black.opacity(0.05).ignoresSafeArea(.all,edges: .all))
    }
}


//struct OrSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrSearchView()
//    }
//}

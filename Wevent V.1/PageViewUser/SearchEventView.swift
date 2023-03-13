
//  SearchEventView.swift
//  Wevent V.1
//
//  Created by You Know on 26/5/2564 BE.

import SwiftUI

struct SearchEventView: View {
    
    @Binding var showSearch : Bool
    
    @State private var isShowing = false
    
    @State var eventsSearch : [EventModel]
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false

    var body: some View {

        NavigationView {
            VStack {
                // Search view
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")

                        TextField("search", text: $searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            print("onCommit")
                        }).foregroundColor(.primary)

                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)

                    if showCancelButton  {
                        Button("Cancel") {
                                UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                                self.searchText = ""
                                self.showCancelButton = false
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.horizontal)
                .navigationBarHidden(showCancelButton) // .animation(.default) // animation does not work properly

                ScrollView {
                    VStack{
                        ForEach(eventsSearch) { eventsSearchs in
                            if eventsSearchs.category.contains(searchText) || eventsSearchs.title.contains(searchText) || eventsSearchs.provinceEvent.contains(searchText) {
                                EventCard(events: eventsSearchs)
                                    
                            }

                        }
                        Spacer(minLength:0)
                    }.padding(10)
                    
                    
                    }
                
                .navigationBarTitle(Text("Search"))
                .toolbar{
                    VStack(alignment: .leading, spacing: 10.0) {
                    Button(action: {
                        self.showSearch.toggle()
                    }, label: {
                        Image(systemName: "clear.fill")
                            .font(Font.custom("Bebas Neue", size: 40))
                            //.foregroundColor(.white)
                    })
                    }
                }
                .resignKeyboardOnDragGesture()
            }
        }
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}


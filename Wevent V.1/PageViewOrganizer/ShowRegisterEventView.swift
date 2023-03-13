//
//  ShowRegisterEventView.swift
//  Wevent V.1
//
//  Created by You Know on 9/6/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn
import SDWebImageSwiftUI
import RefreshableScrollView

struct ShowRegisterEventView: View {
    
    @Binding var showSearch : Bool
    
    @State private var isShowing = false
    
    @State var signMember:[SignMemberModel]
    
    @State var url = ""

    @State var eventID:String
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    @State private var refresh = false
    
    var body: some View {
        VStack{
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text("Event Registation")
                            .font(Font.custom("Bebas Neue", size: 40))
                    }
                    //.foregroundColor(.black)
                    Spacer(minLength:0)
                    VStack{
                        Button(action: {
                            self.showSearch.toggle()
                        }){
                            Image(systemName: "xmark.circle")
                                .font(Font.custom("Bebas Neue", size: 30))
                        }
                    }
                }

            }.padding(.horizontal, 10)
            
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
                        
                        if searchText == "" {
                            ForEach(signMember) { signM in
                                if eventID == signM.eventID {
                                    ListCardSignUser(signMember: signM)
                                    Divider()
                                }

                            }
                        }
                        else {
                            ForEach(signMember) { signM in
                                if eventID == signM.eventID {
                                    if signM.name.contains(searchText) || signM.email.contains(searchText) || signM.lastName.contains(searchText) {
                                        ListCardSignUser(signMember: signM)
                                        Divider()
                                    }
                                }
                                

                            }
                        }
                        
                        Spacer(minLength:0)
                    }.padding(10)
                    
                    
                    }
                
                
                .resignKeyboardOnDragGesture()
            }
        }
    }
}


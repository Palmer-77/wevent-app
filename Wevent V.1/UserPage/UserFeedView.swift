//
//  UserFeedView.swift
//  Wevent V.1
//
//  Created by Palm on 4/5/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn
import SDWebImageSwiftUI
import RefreshableScrollView

struct UserFeedView: View {
    @State var delectAlert = false
    var storageManager = StorageManager()
    @State private var image = UIImage()
    @State var url = ""
    @State var eventID = ""
    
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()

    @StateObject var feeds = FeedViewModel()
    
    @State private var isShowing = false
    @State private var refresh = false
    
    @State private var showCreateFeed = false

    @State var post = ""
    
    var body: some View {
            
            VStack {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10.0) {
                            Text("NEWS FEED")
                                .font(Font.custom("Bebas Neue", size: 40))
                        }
                        
                        //.foregroundColor(.black)
                        Spacer(minLength:0)
                        
                        //.foregroundColor(.black)
                        VStack(alignment: .trailing, spacing: 10.0) {
                            Image(systemName: "qrcode.viewfinder")
                                .font(Font.custom("Bebas Neue", size: 30))
                        }
                        //.foregroundColor(.black)
                    } .padding(.vertical, 3)
                }.padding(.horizontal, 10)
                
                HStack {
                    VStack {
                        if url != "" {
                            VStack {
                                AnimatedImage(url: URL(string: url)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                                .frame(width: 50, height: 50, alignment: .center)
                            
                                
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
                    //รูปuser
                    
                    VStack{
                        Button(action:{
                            self.showCreateFeed.toggle()
                        }){
                            VStack {
                                TextField("คุณคิดอะไรอยู่",text: $post)
                                    .disabled(true)
                            }.padding()
                            
                        }.frame(height: 45)
                        .cornerRadius(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.newECECEC,lineWidth: 1)
                                .opacity(0.3)
                        )
                        
                    }.fullScreenCover(isPresented: self.$showCreateFeed) {
                        CreateFeedView(showCreateFeed: self.$showCreateFeed, eventID: self.$eventID)
                    }
                }.padding(.horizontal, 10)
                
                
                VStack{
                    RefreshableScrollView(refreshing: $refresh, action: {
                        // add your code here
                        // remmber to set the refresh to false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.refresh = false
                            feeds.getAllEvents()
                        }
                    }){
                        ForEach(feeds.feeds){ feed in
                            PostCard(feeds: feed)
                        }
                    }
                }.padding(.horizontal,3)
                Spacer()
        }
}
    
}


struct HideRowSeparatorModifier: ViewModifier {
    static let defaultListRowHeight: CGFloat = 44
    var insets: EdgeInsets
    var background: Color
    
    init(insets: EdgeInsets, background: Color) {
        self.insets = insets
        var alpha: CGFloat = 0
        UIColor(background).getWhite(nil, alpha: &alpha)
        assert(alpha == 1, "Setting background to a non-opaque color will result in separators remaining visible.")
        self.background = background
    }
    
    func body(content: Content) -> some View {
        content
            .padding(insets)
            .frame(
                minWidth: 0, maxWidth: .infinity,
                minHeight: Self.defaultListRowHeight,
                alignment: .leading
            )
            .listRowInsets(EdgeInsets())
            .background(background)
    }
}

extension EdgeInsets {
    static let defaultListRowInsets = Self(top: 0, leading: 16, bottom: 0, trailing: 16)
}

extension View {
    func hideRowSeparator(insets: EdgeInsets = .defaultListRowInsets, background: Color = .white) -> some View {
        modifier(HideRowSeparatorModifier(insets: insets, background: background))
    }
}


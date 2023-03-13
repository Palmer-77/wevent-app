//
//  showJoinEventView.swift
//  Wevent V.1
//
//  Created by You Know on 9/6/2564 BE.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct ShowJoinEventView: View {
    let storage = Storage.storage().reference()
    let db = Firestore.firestore()
    
    @Binding var showJoinEvent:Bool
    @State var codeEvent:String
    
    @State var url = ""
    
    @State var category:String
    @State var title:String
    @State var datestart:String
    @State var dateend:String
    @State var location:String
    @State var path:String
    @State var provinceEvent:String
    @State var formatEvent:String
    @State var timeEnd:String
    @State var timeStart:String
    @State var organizerID:String
    
    
    
    var body: some View {
        VStack{
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text("Register Event")
                            .font(Font.custom("Bebas Neue", size: 40))
                    }
                    
                    //.foregroundColor(.black)
                    Spacer(minLength:0)
                    
                    VStack{
                        Button(action: {
                            self.showJoinEvent.toggle()
                        }){
                            Image(systemName: "xmark.circle")
                                .font(Font.custom("Bebas Neue", size: 30))
                        }
                    }
                }
                
            }.padding(.horizontal, 10)
            
            VStack{
                if url != "" {
                    VStack {
                        AnimatedImage(url: URL(string: url)!)
                            .resizable()
                            .clipped()
                            .frame(height: 200)
                    }.padding(.horizontal,15)
                    .cornerRadius(10)
                    .padding(.bottom,10)
                }
                else {
                    VStack {
                        Image("Wevent-2")
                            .resizable()
                            .clipped()
                            .frame(height: 200)
                    }.padding(.horizontal,15)
                    .cornerRadius(10)
                    .padding(.bottom,10)
                }
                    
                VStack(alignment: .leading){
                    Text(category)
                        .font(.caption)
                        .bold()
                    Text(title)
                        .font(.title3)
                        .bold()
                    HStack{
                        Image(systemName: "xmark.circle")
                            .font(.callout)
                        Text(provinceEvent)
                            .font(.callout)
                    }
                    HStack{
                        Image(systemName: "xmark.circle")
                            .font(.callout)
                        Text(location)
                            .font(.callout)
                    }
                    HStack{
                        Image(systemName: "xmark.circle")
                            .font(.callout)
                        Text(formatEvent)
                            .font(.callout)
                    }
                    HStack{
                        Image(systemName: "xmark.circle")
                            .font(.callout)
                        Text("\(datestart) - \(dateend)")
                            .font(.callout)
                    }
                    HStack{
                        Image(systemName: "xmark.circle")
                            .font(.callout)
                        Text("\(timeStart) - \(timeEnd)")
                            .font(.callout)
                    }
                }.padding(.horizontal, 10)
                .padding(10)
                .background(
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue,lineWidth: 2)
                    }
                )

            }
            .onAppear{
                let storage = Storage.storage().reference()
                storage.child("Events/Banner/\(path)").downloadURL{(url,err) in
                    if err != nil {
                        print((err?.localizedDescription)!)
                        return
                    }
                    self.url = "\(url!)"
                }
            }
            
            Spacer()
        }
    }
    
}


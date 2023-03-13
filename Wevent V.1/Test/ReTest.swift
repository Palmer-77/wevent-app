//
//  ReTest.swift
//  Wevent V.1
//
//  Created by Palm on 1/5/2564 BE.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseFirestore

struct ReTest: View {
    @AppStorage("log_organizer") var log_organizer = false
    @AppStorage("organizer") var organizer = false
    @AppStorage("log_user") var log_user = false
    @AppStorage("log_switch") var log_switch = false
    @EnvironmentObject var userModel : UserModel
    @State var isShowTabUser = false
    @State var isShowTabOrganizer = false

    
//    @State var switchOrganizerMode = false
//    @State var switchUserMode = false

    
        
    var body: some View {
        VStack {
            VStack {
                Text("WEVENT")
                    .font(Font.custom("Bebas Neue", size: 40))
            }
            if true {
                VStack {
                    Button(action: {
                        self.log_user = true
                        self.log_switch = false
                        self.log_organizer = false
                    }) {
                        VStack {
                            Image(systemName: "person.circle")
                                
                                .font(Font.custom("Bebas Neue", size: 100))
                            Text("User Mode")
                                    .font(Font.custom("Bebas Neue", size: 25))
                        }.foregroundColor(.newGreenSky)
                        
                    }
                }
                //.fullScreenCover(isPresented: $switchUserMode){
//                    UserIndexView(switchUserMode: self.switchUserMode)
//                }
                .padding()

            }
            
            
            if self.organizer {
                VStack{
                    Text("OR")
                            .font(Font.custom("Bebas Neue", size: 20))
                }.padding()
                
                VStack {
                    Button(action: {
                        self.log_user = false
                        self.log_switch = false
                        self.log_organizer = true
                    }) {
                        VStack {
                            Image(systemName: "person.circle.fill")
                                
                                .font(Font.custom("Bebas Neue", size: 100))
                            Text("Organizer Mode")
                                    .font(Font.custom("Bebas Neue", size: 25))
                        }.foregroundColor(.new413C69)
                    }
               }
                .padding()
                //.fullScreenCover(isPresented: $switchOrganizerMode){
//                    OrganizerIndexView(switchOrganizerMode: self.switchOrganizerMode)
//                }

            }

        }
  
    }
    
}



//struct ReTest_Previews: PreviewProvider {
//    static var previews: some View {
//        ReTest()
//            .environmentObject(UserModel())
//    }
//}

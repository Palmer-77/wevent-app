//
//  UserSettingView.swift
//  Wevent V.1
//
//  Created by Palm on 2/5/2564 BE.
//

import SwiftUI
import Firebase
import GoogleSignIn
import CoreImage.CIFilterBuiltins

struct UserSettingView: View {
    @State var switchMode = false
    @AppStorage("log_status") var log_Status = false
    @AppStorage("log_data") var log_data = false
    @AppStorage("log_login") var log_login = false
    @AppStorage("currentPage") var currentPage = 1
    let user = Auth.auth().currentUser
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Setting")
                        .font(Font.custom("Bebas Neue", size: 40))
                }
                //.foregroundColor(.black)
                
                Spacer(minLength: 0)
                
            }
            .padding(.horizontal, 10)
            
                
            VStack {
                Button(action: {
                    self.switchMode.toggle()
                }) {
                    
                    Text("Organizer Mode")
                        .foregroundColor(.white)
                }
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 200)
                .background(Color.gray)
                .cornerRadius(8)
                //.clipShape(Capsule())
                .padding(.bottom, 20)
            }.padding(.horizontal, 10)
            .fullScreenCover(isPresented: $switchMode) {
                //OrganizerIndexView()
            }

            
            VStack {
                Button(action: {
                    
                    try! Auth.auth().signOut()
                    GIDSignIn.sharedInstance()?.signOut()
                    UserDefaults.standard.set(false, forKey: "log_status")
                    UserDefaults.standard.set(true, forKey: "log_data")
                    UserDefaults.standard.set(false, forKey: "log_login")
                    UserDefaults.standard.set(1, forKey: "currentPage")

                }) {
                
                Text("ออกจากระบบ")
                    .foregroundColor(.white)
            }
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width - 200)
            .background(Color.red)
            .cornerRadius(8)
            //.clipShape(Capsule())
            .padding(.bottom, 20)
            }.padding(.horizontal, 10)
            
            Spacer(minLength: 0)
        }
        //.background(Color.black.opacity(0.05).ignoresSafeArea(.all,edges: .all))
    }
}

struct UserSettingView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingView()
    }
}

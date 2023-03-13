//
//  ScanView.swift
//  Wevent V.1
//
//  Created by Palm on 28/4/2564 BE.
//

import SwiftUI
import CodeScanner

struct ScanView: View {
    @Binding var showScan : Bool
    @State var codeEvent:String = ""
    
    @State private var isShowingScanner = false
    @State var name: String = ""
    @State var emailAddress:String = ""
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
       self.isShowingScanner = false
       // more code to come
        switch result {
        case .success(let data):
            self.name = "\(data)"
                self.codeEvent = "\(data)"
                   print("Success with \(data)")
               case .failure(let error):
                   print("Scanning failed \(error)")
        }
    }
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10.0) {
                Text("Register Event")
                    .font(Font.custom("Bebas Neue", size: 40))
                }
                Spacer(minLength: 0)
                VStack(alignment: .leading, spacing: 10.0) {
                Button(action: {
                    self.showScan.toggle()
                }, label: {
                    Image(systemName: "clear.fill")
                        .font(Font.custom("Bebas Neue", size: 30))
                        //.foregroundColor(.white)
                })
                }
            }.padding(.horizontal, 5)
            Form {
                Section(header: Text("ลงทะเบียนเข้าร่วมอีเว้นท์")){
                    HStack {
                        Image(systemName: "chevron.left.slash.chevron.right")
                        TextField("กรอก code",text: self.$codeEvent)
                        Button(action: {
                            self.isShowingScanner = true
                            
                        }) {
                            Image(systemName: "qrcode.viewfinder")
                                .font(Font.custom("Bebas Neue", size: 30))
                            
                        }.sheet(isPresented: $isShowingScanner) {
                            ZStack{
                                VStack{
                                    Text("Wevent Scan")
                                        .font(Font.custom("Bebas Neue", size: 40))
                                        .foregroundColor(Color.white)
                                    
                                    Spacer()
                                    Text("ใช้สแกนได้แค่ในแอพ Wevent เท่านั้น")
                                        .foregroundColor(Color.white)
                                }.padding()
                                CodeScannerView(codeTypes: [.qr],  completion: self.handleScan)
                                    .frame(width: 300, height: 300, alignment: .center)
                                    .cornerRadius(10)
                                
                            }.frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height , alignment: .center)
                            .background(Color.black)
                            
                        }
                    }
                }
            }.frame(height:100)
            .padding(10)
            .padding(.horizontal, 20)
            .cornerRadius(10)
            HStack {
                Button(action: {}) {
                                
                                Text("เข้าร่วม")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width/3)
                                
                            }.background(
                            
                                LinearGradient(gradient: .init(colors: [Color.blue]), startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(8)
                            //.offset(y: -40)
                            //.padding(.bottom, -40)
                            .shadow(radius: 15)
                Button(action: {
                    self.codeEvent = ""
                }) {
                                
                                Text("ยกเลิก")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width/3)
                                
                            }.background(
                            
                                LinearGradient(gradient: .init(colors: [Color.red]), startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(8)
                            //.offset(y: -40)
                            //.padding(.bottom, -40)
                            .shadow(radius: 15)
            }
            
            Spacer(minLength: 0)
        }
    }

}

//struct ScanView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScanView()
//    }
//}

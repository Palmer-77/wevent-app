//
//  QRCodeView.swift
//  Wevent V.1
//
//  Created by Palm on 30/4/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SDWebImageSwiftUI
import CodeScanner

struct QRCodeView: View {
    @Binding var showQRcode : Bool
    @State var showJoinEvent = false
    @State var alertNoEvent = false
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State var url = ""
    @State var name = ""
    @State var lastName = ""
    
    @State var codeEvent:String = ""
    @State private var isShowingScanner = false
    
    var image = "Wevent"
    
    @State var category = ""
    @State var title = ""
    @State var datestart = ""
    @State var dateend = ""
    @State var location = ""
    @State var path = ""
    @State var provinceEvent = ""
    @State var formatEvent = ""
    @State var timeEnd = ""
    @State var timeStart = ""
    @State var organizerID = ""
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
       self.isShowingScanner = false
       // more code to come
        switch result {
        case .success(let data):
                self.codeEvent = "\(data)"
                   print("Success with \(data)")
                    self.showJoinEvent = false
                    checkEvent()
               case .failure(let error):
                   print("Scanning failed \(error)")
        }
    }
    
    
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
        VStack {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text("Wevent")
                            .font(Font.custom("Bebas Neue", size: 40))
                    }

                    //.foregroundColor(.black)
                    Spacer(minLength:0)
                    VStack{
                        Button(action: {
                            self.showQRcode.toggle()
                        }){
                            Image(systemName: "xmark.circle")
                                .font(Font.custom("Bebas Neue", size: 30))
                        }
                    }
                }

            }.padding(.horizontal, 10)
            VStack{
                Text("QR-Code ของฉัน")
                     
                ZStack{
                    
                    Image(uiImage: generateQRCode(from: "\(user?.uid ?? "")"))
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        //.fixedSize()
                        .frame(width: 300, height: 300)
                    
                    VStack {
                        if url != "" {
                            VStack {
                                AnimatedImage(url: URL(string: url)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                                .frame(width: 60, height: 60)
                                
                            }.padding()

                        }
                        else {
                            ZStack{
                                Image("Wevent-2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                                .frame(width: 60, height: 60)
                                Loader()
                            }
                           
                        }
                        
                        
                        //.padding()
                    }
                }
                
                VStack{
                    
                    VStack(alignment: .center) {
                        Text("User")
                            .font(.system(size: 16))
                            .bold()
                            //.foregroundColor(.white)
                            
                        
                        Text("\(name) \(lastName)")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            //.foregroundColor(.white)
                        
                        Text(user?.email ?? "")
                            .font(.system(size: 18, weight: .bold, design: .default))
                            //.foregroundColor(.white)
                    }.padding(10)
                }
            }.padding(.horizontal)
            
            

            HStack{
                VStack{
                    Divider()
                }
                Text("หรือ")
                    .font(.system(size: 14, weight: .bold, design: .default))
                VStack{
                    Divider()
                }
            }
            HStack{
                VStack{
                    Image(systemName: "qrcode.viewfinder")
                        .font(Font.custom("Bebas Neue", size: 50))
                        .foregroundColor(.black)
                        
                }.padding(.vertical)
                .padding(.horizontal,10)
                VStack{
                    HStack{
                        Text("สแกนคิวอาร์โค้ดผู้เข้าร่วม")
                            .font(.body)
                            .bold()
                        Spacer()
                    }
                }.padding(.vertical,10)
                .padding(.horizontal,5)
                 .foregroundColor(Color.black)
            }
            .background(Color.newECECEC)
            .cornerRadius(10)
            .padding(8)
            .onTapGesture {
                self.isShowingScanner.toggle()
            }
            .sheet(isPresented: $isShowingScanner) {
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
            .alert(isPresented: $alertNoEvent) {
                Alert(title: Text("แจ้งเตือน"), message: Text("ไม่พบอีเว้นท์นี้โปรดสแกนใหม่ หรือ QR-Code "), dismissButton: .default( Text("ตกลง"))
                )
            }
            .fullScreenCover(isPresented: $showJoinEvent){
                ShowJoinEventView(showJoinEvent: self.$showJoinEvent, codeEvent: codeEvent, category: category, title: title, datestart: datestart, dateend: dateend, location: location, path: path, provinceEvent: provinceEvent, formatEvent: formatEvent, timeEnd: timeEnd, timeStart: timeStart, organizerID: organizerID)
            }
            
            Spacer(minLength:0)
        }.padding(10)
        .onAppear {
            let storage = Storage.storage().reference()
            storage.child("Users/Profile/ProfileID-\(user!.uid)").downloadURL{(url,err) in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                self.url = "\(url!)"
            }
            
            db.collection("Users").document(user?.uid ?? "").addSnapshotListener { [self] (document, error) in
                guard let docs = document else{
                    print("num")
                    return
                }
                if docs.exists {
                    self.name = docs.data()?["name"] as! String
                    self.lastName = docs.data()?["lastName"] as! String
                    print(name)
                }
                 else {
                    print("Document does not exist ไม่มีข้อมูล")
                }
            }
        }
        
    }
    
    
    func checkEvent() {

        db.collection("Events").whereField("eventID", isEqualTo: codeEvent).getDocuments{ (snap, err) in
            guard let docs = snap else{
                print("num")
                return
            }
            if docs.count == 0 {
                self.alertNoEvent.toggle()
            }
            else {
                db.collection("Events").document("\(codeEvent)").getDocument { [self] (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                                        if let data = data {
                                            print("date", data)
                                            self.category = "\(data["category"] as? String ?? "")"
                                            self.title = "\(data["title"] as? String ?? "")"
                                            self.formatEvent = "\(data["formatEvent"] as? String ?? "")"
                                            self.timeStart = "\(data["timeStart"] as? String ?? "")"
                                            self.timeEnd = "\(data["timeEnd"] as? String ?? "")"
                                            self.location = "\(data["location"] as? String ?? "")"
                                            self.datestart = "\(data["dateStart"] as? String ?? "")"
                                            self.dateend = "\(data["dateEnd"] as? String ?? "")"
                                            self.organizerID = "\(data["organizerID"] as? String ?? "")"
                                            self.provinceEvent = "\(data["provinceEvent"] as? String ?? "")"
                                            self.path = "\(data["path"] as? String ?? "")"
                                            
                                        }
                    } else {
                        print("Document does not exist ไม่มีข้อมูล")
                    }
                }
                self.showJoinEvent.toggle()
                print(showJoinEvent)
            }
            
        }
    }
    
}

//struct QRCodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        QRCodeView()
//    }
//}

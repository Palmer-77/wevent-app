//
//  RegisterEventView.swift
//  Wevent V.1
//
//  Created by You Know on 3/6/2564 BE.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner

struct RegisterEventView: View {
    
    @Binding var getRegisterEvent:Bool
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    let storageRef = Storage.storage().reference()
    
    var eventDetail : EventModel
    
    @State var codeUser:String = ""
    
    @State private var isShowingScanner = false
    
    @State var checkShowUser = false
    @State var checkShowUserSign = false
    
    @State var showQRCode = false
    
    @State var url = ""
    @State var urlEvent = ""
    
    
    @State var name = ""
    @State var lastName = ""
    @State var email = ""
    
    @State var alertNojoin = false
    @State var alertSaveImg = false
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
       self.isShowingScanner = false
       // more code to come
        switch result {
        case .success(let data):
                self.codeUser = "\(data)"
                   print("Success with \(data)")
               case .failure(let error):
                   print("Scanning failed \(error)")
        }
    }
    
    var body: some View {
        ScrollView{
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text("Registater Event")
                            .font(Font.custom("Bebas Neue", size: 40))
                    }

                    //.foregroundColor(.black)
                    Spacer(minLength:0)
                    VStack{
                        Button(action: {
                            self.getRegisterEvent.toggle()
                        }){
                            Image(systemName: "xmark.circle")
                                .font(Font.custom("Bebas Neue", size: 30))
                        }
                    }
                }

            }.padding(.horizontal, 10)
            VStack{
                Text("ลงทะเบียนเข้าร่วมอีเว้นท์")
                    .font(.title2)
                    .bold()
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
                
            }.onChange(of: codeUser, perform: { value in
                checkUser()
            })

            HStack{
                VStack{
                    Divider()
                }.padding(10)
                
                Text("หรือ")
                    .font(.callout)
                    .bold()
                
                VStack{
                    Divider()
                }.padding(10)
            }
            
            HStack{
                VStack{
                    Image(systemName: "qrcode")
                        .font(Font.custom("Bebas Neue", size: 50))
                        .foregroundColor(.black)
                }.padding(.vertical)
                .padding(.horizontal,10)
                VStack{
                    HStack{
                        Text("คิวอาร์โค้ดลงชื่อเข้าร่วมอีเว้นท์")
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
                self.showQRCode.toggle()
                if checkShowUser {
                    self.checkShowUser = false
                }
            }
                            if checkShowUser {
                                HStack{
                                    VStack{
                                        Divider()
                                    }.padding(10)
                                    
                                    Text("ผลการสแกน")
                                        .font(.callout)
                                        .bold()
                                    
                                    VStack{
                                        Divider()
                                    }.padding(10)
                                }
                                VStack {
                                    if url != "" {
                                        AnimatedImage(url: URL(string: url)!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle())
                                            .shadow(radius: 10)
                                            .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                                            .frame(width: 150 , height: 150, alignment: .center)
                                    }
                                    else {
                                       Image("Wevent-2")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle())
                                            .shadow(radius: 10)
                                            .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                                            .frame(width: 150 , height: 150, alignment: .center)
                                    }
                                    Text("\(name) \(lastName)")
                                        .font(Font.custom("Bebas Neue", size: 30))
                                    Text(email)
                                        .font(.callout)
                                    
                                    if checkShowUserSign {
                                        Text("ลงชื่อเข้าอีเว้นท์เรียบร้อยแล้ว")
                                            .font(.title)
                                            .bold()
                                            .padding(10)
                                    }
                                    else {
                                        Button(action: {
                                            let doc: [String: Any]  = [
                                                "signmembers" : FieldValue.arrayUnion(["\(codeUser)"])
                                            ]
                                            db.collection("Events").document(eventDetail.id).updateData(doc){ err in
                                                if let err = err {
                                                    print("Error writing document: \(err)")
                                                } else {
                                                    print("Document successfully written!")
                                                    checkUser()
                                                }
                                            }
                                            let dTime = Date()
                                            
                                            let convert = DateFormatter()
                                            
                                            convert.dateFormat = "d/MM/YYYY - HH:mm"
                                            
                                            var ref: DocumentReference? = nil
                                            
                                           ref = db.collection("SignMembers").addDocument(data: [
                                                "date" : "\(convert.string(from: dTime))",
                                                "eventID" : "\(eventDetail.id)",
                                                "signMembersID" : "",
                                                "timeStamp" : FieldValue.serverTimestamp(),
                                                "userID" : "\(codeUser)"
                                            ])
                                            
                                            db.collection("SignMembers").document(ref?.documentID ?? "").updateData([
                                                "signMembersID" : "\(ref?.documentID ?? "")"
                                            ])
                                            
                                        }, label: {
                                            HStack{
                                                Image(systemName: "person.crop.circle.fill.badge.plus")
                                                    .font(.title2)
                                                    .foregroundColor(.white)
                                                Text("ลงชื่อ")
                                                    .font(.title2)
                                                    .bold()
                                                    .foregroundColor(.white)
                                            }.padding(10)
                                            .background(Color.newGreenK)
                                            .cornerRadius(5)
                                        })
                                    }
                                }.padding(.vertical)
                                .padding(.horizontal,10)
                                
                                
                                
                                VStack{
                                    Divider()
                                        .padding(10)
                                }
                            }
                            else {

                            }
            
            if showQRCode {
                VStack{
                    VStack{
                        qrCode
                        VStack{
                            Button(action: {
                                let image = qrCode.snapshot()
                                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            }, label: {
                                VStack{
                                    Text("ดาวน์โหลด")
                                        .font(.title2)
                                        .bold()
                                        .padding(5)
                                        .foregroundColor(.black)
                                }.padding(5)
                                .background(Color.yellow)
                                .cornerRadius(5)
                            })
                        }
                    }.padding(15)
                    
                }.background(Color.newECECEC)
                .cornerRadius(10)
                .padding(.horizontal,10)
                
            }
            else {
                
            }

            
            Spacer()
        }.alert(isPresented: $alertNojoin) {
            Alert(title: Text("แจ้งเตือน"), message: Text("ผู้ใช้ไม่ได้ลงทะเบียนเข้าร่วมอีเว้นท์นี้"), dismissButton: .destructive( Text("ตกลง"))
                {
                self.getRegisterEvent.toggle()
            }
            )
        }
        .onAppear{
            setEvent()
        }
    }
    
    var qrCode: some View {
            VStack {
                HStack{
                    VStack{
                        Divider()
                    }.padding(10)
                    
                    Text("QR Code อีเว้นท์")
                        .font(.callout)
                        .bold()
                    
                    VStack{
                        Divider()
                    }.padding(10)
                }
                
                VStack{
                    Image(uiImage: generateQRCode(from: "\(eventDetail.id)"))
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        //.fixedSize()
                        .frame(width: 300, height: 300)
                }
                
                VStack{
                    CardEventShow(eventDetail: eventDetail, urlEvent: urlEvent)
                }.padding(.horizontal,20)

                Divider()
                    .padding(10)
            }.background(Color.newECECEC)
    }
    
    func setEvent() {
        let storage = Storage.storage().reference()
        storage.child("Events/Banner/\(eventDetail.path)").downloadURL{(url,err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            self.urlEvent = "\(url!)"
            print("ทำงานแล้ว")
        }
    }
    
    func checkUser() {
        let storage = Storage.storage().reference()
        storage.child("Users/Profile/ProfileID-\(codeUser)").downloadURL{(url,err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            self.url = "\(url!)"
        }
        
        db.collection("Users").document(codeUser).addSnapshotListener { (snap, err) in
            guard let docs = snap else{
                print("num")
                return
            }
            if docs.exists {
                self.name = String(docs.data()?["name"] as! String)
                self.lastName = String(docs.data()?["lastName"] as! String)
                self.email = String(docs.data()?["email"] as! String)
            }
        }
        
        db.collection("Events").document(eventDetail.id).addSnapshotListener { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        
                        let registers = querySnapshot?.data()!["registermembers"] as! [String]
                        let signmembers = querySnapshot?.data()!["signmembers"] as! [String]
                        //for register in registers {
                            //let register = document.data()["registermember"] as! String
                        if registers.contains(codeUser) {
                                self.checkShowUser = true
                            if showQRCode {
                                self.showQRCode = false
                            }
                            }
                            else {
                                self.checkShowUser = false
                                self.alertNojoin = true
                            }
                        if signmembers.contains(codeUser) {
                                self.checkShowUserSign = true
                            }
                            else {
                                self.checkShowUserSign = false
                            }

                        //}
                    }
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
    
}



//
//  CreateView.swift
//  Wevent version 0.0.1
//
//  Created by Palm on 24/3/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn


struct OrCreateView: View {
    
    let data = [
        "detail" : "",
    "title" : "",
    "category" : "",
    "organizerID" : "",
    "dateStart" : "",
    "dateEnd" : "",
    "location" : "",
    "eventID" : "",
    "path" : "BannerID-",
    "registermembers" : [],
    "signmembers" : [],
    "facebook" : "",
    "numpeople" : 10,
    "statusEvent":true
    ] as [String : Any]
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    var storageManager = StorageManager()
    
    @State private var image = UIImage()
    @State private var showSheet = false
    
    @State private var checked = false
    @State var show = false
    @State var date = Date()
    
    @State var name: String = ""
    @State var lastname: String = ""
    @State var tel: String = ""
    @State var email: String = ""
    @State var birthday: String = ""
    @State var sex: String = "ไม่ระบุ"
    @State var addressCompany:String = ""
    @State var addressUser:String = ""
    @State var categoryEvent:String = ""
    @State var emailOther:String = ""
    @State var facebook:String = ""
    @State var instagram:String = ""
    @State var nameCompany:String = ""
    @State var provinceUser:String = ""
    @State var twitter:String = ""
    @State var webSite:String = ""
    @State var youtube:String = ""
    
    
    @State var alert = false
    @State var alert2 = false
    @State var alertMsg = ""

    
    @State private var letter = ""
    

    
    
    let genderOptions = ["ชาย", "หญิง", "ไม่ระบุ"]
    let proVince = ["ไม่ระบุ","กระบี่","กรุงเทพมหานคร","กาญจนบุรี","กาฬสินธุ์","กำแพงเพชร","ขอนแก่น","จันทบุรี","ฉะเชิงเทรา" ,"ชลบุรี","ชัยนาท","ชัยภูมิ","ชุมพร","เชียงราย","เชียงใหม่","ตรัง","ตราด","ตาก","นครนายก","นครปฐม","นครพนม","นครราชสีมา" ,"นครศรีธรรมราช","นครสวรรค์","นนทบุรี","นราธิวาส","น่าน","บุรีรัมย์","ปทุมธานี","ประจวบคีรีขันธ์","ปราจีนบุรี","ปัตตานี" ,"พะเยา","พังงา","พัทลุง","พิจิตร","พิษณุโลก","เพชรบุรี","เพชรบูรณ์","แพร่","ภูเก็ต","มหาสารคาม","มุกดาหาร","แม่ฮ่องสอน" ,"ยโสธร","ยะลา","ร้อยเอ็ด","ระนอง","ระยอง","ราชบุรี","ลพบุรี","ลำปาง","ลำพูน","เลย","ศรีสะเกษ","สกลนคร","สงขลา" ,"สตูล","สมุทรปราการ","สมุทรสงคราม","สมุทรสาคร","สระแก้ว","สระบุรี","สิงห์บุรี","สุโขทัย","สุพรรณบุรี","สุราษฎร์ธานี" ,"สุรินทร์","หนองคาย","หนองบัวลำภู","อยุธยา","อ่างทอง","อำนาจเจริญ","อุดรธานี","อุตรดิตถ์","อุทัยธานี","อุบลราชธานี"]

    
    
    init(){
        setBirthday()
        UITextView.appearance().backgroundColor = .clear
    }

    var body: some View {
        
        VStack(alignment: .center){
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text("Create Event")
                            .font(Font.custom("Bebas Neue", size: 40))
                    }
                    
                    //.foregroundColor(.black)
                    Spacer(minLength:0)
                    
                   
                }
                
            }.padding(.horizontal, 10)
            .padding(.bottom, 2)
            VStack{
                
                HStack{
                    VStack{
                        HStack{
                            Text("อีเว้นท์ขนาดเล็ก")
                                .font(.body)
                                .bold()
                            Spacer()
                        }
                        HStack{
                            Text("ขนาดไม่เกิน 100 คน")
                                .font(.caption)
                                .bold()
                            Spacer()
                        }
                    }.padding(.horizontal)
                     .foregroundColor(Color.black)
                    VStack{
                        Image("Wevent-2")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                            .frame(width: 80 , height: 80, alignment: .center)
                    }.padding(.vertical)
                    .padding(.horizontal)
                    
                }
                .background(Color.newECECEC)
                .cornerRadius(10)
                .onTapGesture {
                    self.showSheet.toggle()
                }
                .padding(5)
                .fullScreenCover(isPresented: self.$showSheet) {
                    CreateEventView(getCreate: self.$showSheet, size: "เล็ก" , min: 1)
                }
                
                ZStack{
                    HStack{
                        VStack{
                            HStack{
                                Text("อีเว้นท์ขนาดกลาง")
                                    .font(.body)
                                    .bold()
                                Spacer()
                            }
                            HStack{
                                Text("ขนาด 100 คน ขึ้นไปไม่เกิน 500 คน")
                                    .font(.caption)
                                    .bold()
                                Spacer()
                            }
                        }.padding(.horizontal)
                        VStack{
                            Image("Wevent-2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                                .frame(width: 80 , height: 80, alignment: .center)
                        }.padding(.vertical)
                        .padding(.horizontal)
                        
                    }
                    .background(Color.newECECEC)
                    .cornerRadius(10)
                    .padding(5)
                    .opacity(0.7)
                    VStack{
                        Image(systemName: "key.icloud.fill")
                            .font(Font.custom("Bebas Neue", size: 50))
                            .padding(10)
                    }
                }
                
                
                ZStack{
                    HStack{
                        VStack{
                            HStack{
                                Text("อีเว้นท์ขนาดใหญ่")
                                    .font(.body)
                                    .bold()
                                Spacer()
                            }
                            HStack{
                                Text("ขนาด 500 คน ขึ้นไปไม่เกิน 1000 คน")
                                    .font(.caption)
                                    .bold()
                                Spacer()
                            }
                        }.padding(.horizontal)
                        VStack{
                            Image("Wevent-2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .overlay(Circle().stroke(Color.blue, lineWidth: 3))
                                .frame(width: 80 , height: 80, alignment: .center)
                        }.padding(.vertical)
                        .padding(.horizontal)
                        
                    }
                    .background(Color.newECECEC)
                    .cornerRadius(10)
                    .padding(5)
                    .opacity(0.7)
                    VStack{
                        Image(systemName: "key.icloud.fill")
                            .font(Font.custom("Bebas Neue", size: 50))
                            .padding(10)
                    }
                }
                
            }
            Spacer()
            
        }
        
        
    }
    
    
    func setBirthday(){
        let convert = DateFormatter()
        
        convert.dateFormat = "dd/MM/YYYY"
        
        self.birthday = "\(convert.string(from: date))"
        
        
    }
    
}

    
    

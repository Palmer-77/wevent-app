//
//  EditEventView.swift
//  Wevent V.1
//
//  Created by You Know on 3/6/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn
import SDWebImageSwiftUI
import Mantis

struct EditEventView: View {
    
    @Binding var getEditView: Bool
    
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    var storageManagerEvent = StorageManagerEvent()
    
    @State private var image = UIImage()
    @State private var showSheet = false
    
    @State private var checked = false
    @State var show = false
    @State var isShowing = false
    
    var eventDetail : EventModel
    
    @State var DateStart = Date()
    @State var DateEnd = Date()
    @State var TimeStart = Date()
    @State var TimeEnd = Date()
    
    @State var addressCompany: String = ""
    @State var category: String = ""
    @State var dateStart: String = ""
    @State var dateEnd: String = ""
    @State var email: String = ""
    @State var detail: String = ""
    @State var eventID: String = ""
    @State var formatEvent:String = ""
    @State var location:String = ""
    @State var nameCompany:String = ""
    @State var numpeople:String = ""
    @State var provinceEvent:String = ""
    @State var title:String = ""
    @State var timeStart:String = ""
    @State var timeEnd:String = ""
    @State var facebook:String = ""
    @State var instagram:String = ""
    @State var twitter:String = ""
    @State var webSite:String = ""
    @State var youtube:String = ""
    @State var tel:String = ""
    
    
    @State var alert = false
    @State var alert2 = false
    @State var alertMsg = ""

    
    //@State private var letter = "b"
    
    @State var urlImage = ""
    
    @State private var showingCropper = false
    @State private var cropShapeType: Mantis.CropShapeType = .rect
    @State private var presetFixedRatioType: Mantis.PresetFixedRatioType = .canUseMultiplePresetFixedRatio()
    
    //let genderOptions = ["ชาย", "หญิง", "ไม่ระบุ"]
    let proVince = ["ไม่ระบุ","กระบี่","กรุงเทพมหานคร","กาญจนบุรี","กาฬสินธุ์","กำแพงเพชร","ขอนแก่น","จันทบุรี","ฉะเชิงเทรา" ,"ชลบุรี","ชัยนาท","ชัยภูมิ","ชุมพร","เชียงราย","เชียงใหม่","ตรัง","ตราด","ตาก","นครนายก","นครปฐม","นครพนม","นครราชสีมา" ,"นครศรีธรรมราช","นครสวรรค์","นนทบุรี","นราธิวาส","น่าน","บุรีรัมย์","ปทุมธานี","ประจวบคีรีขันธ์","ปราจีนบุรี","ปัตตานี" ,"พะเยา","พังงา","พัทลุง","พิจิตร","พิษณุโลก","เพชรบุรี","เพชรบูรณ์","แพร่","ภูเก็ต","มหาสารคาม","มุกดาหาร","แม่ฮ่องสอน" ,"ยโสธร","ยะลา","ร้อยเอ็ด","ระนอง","ระยอง","ราชบุรี","ลพบุรี","ลำปาง","ลำพูน","เลย","ศรีสะเกษ","สกลนคร","สงขลา" ,"สตูล","สมุทรปราการ","สมุทรสงคราม","สมุทรสาคร","สระแก้ว","สระบุรี","สิงห์บุรี","สุโขทัย","สุพรรณบุรี","สุราษฎร์ธานี" ,"สุรินทร์","หนองคาย","หนองบัวลำภู","อยุธยา","อ่างทอง","อำนาจเจริญ","อุดรธานี","อุตรดิตถ์","อุทัยธานี","อุบลราชธานี"]

    let categoryT = ["อาหารและเครื่องดื่ม","ท่องเที่ยว","ช้อปปิ้ง","ครอบครัวและเด็ก", "บ้านและการตกแต่ง","การ์ตูนและเกม","การพัฒนาตนเอง","การศึกษา","ทศกาลและประเพณี","รถยนต์และยานพาหนะ","แฟชั่น","การเงินและธนาคาร","ไอทีและเทคโนโลยี","สุขภาพและความงาม","ดนตรีและการแสดง","พืชและสัตว์","เพื่อสังคม","งานและอาชีพ","อุตสาหกรรม","แต่งงาน","ศิลปะและการออกแบบ","กีฬาและสันทนาการ","หนังสือ","ธุรกิจ"]
    
    @State var eDit = false

    var body: some View {
        
        NavigationView{
            ScrollView{
                ZStack {
                    
                    AnimatedImage(url: URL(string: self.urlImage))
                        .resizable()
                        .clipped()
                    
                    Image(uiImage: self.image)
                        .resizable()
                        .clipped()
                        //.clipShape(Circle())

                    HStack{
                        VStack{
                            Image(systemName: "camera.circle.fill")
                                .font(Font.custom("Bebas Neue", size: 50))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .onTapGesture {
                                    self.showSheet.toggle()
                                }
                        }.sheet(isPresented: $showSheet) {
                            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                        }
                        .onChange(of: image, perform: { value in
                            self.eDit = true
                        })
                        if eDit {
                            VStack{
                                Image(systemName: "crop")
                                    .font(Font.custom("Bebas Neue", size: 50))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .onTapGesture {
                                        self.showingCropper.toggle()
                                    }
                                     
                            }.fullScreenCover(isPresented: $showingCropper) {
                                ImageCropper(image: $image,
                                                         cropShapeType: $cropShapeType,
                                                         presetFixedRatioType: $presetFixedRatioType)
                                                .ignoresSafeArea()
                            }
                        }
                        
                        
                        
                    }
                    
                    
                    
//                        .onChange(of: image, perform: { image in
//                            storageManager.upload(image: image,path:"ProfileID-\(user!.uid)")
//                        })
                }.background(Color.newECECEC)
                .frame(height: 250)
                .cornerRadius(10)
                .padding(.horizontal,10)
                .onAppear {
                    let storage = Storage.storage().reference()
                    storage.child("Events/Banner/\(eventDetail.path)").downloadURL{(url,err) in
                        if err != nil {
                            print((err?.localizedDescription)!)
                            return
                        }
                        self.urlImage = "\(url!)"
                    }
                }
                
                
                
                VStack(alignment: .leading) {
                    Text("รายละเอียดอีเว้นท์")
                        .font(Font.custom("Bebas Neue", size: 24))
                        .padding(5)
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            VStack{
                                Text("ชื่ออีเว้นท์")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "person.circle")
                                        .foregroundColor(Color.black)
                                    TextField("กรอกชื่อ", text: $title)
                                        .foregroundColor(Color.black)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        VStack(alignment: .leading){
                            VStack{
                                Text("หมวดหมู่อีเว้นท์")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    Image(systemName: "mappin.and.ellipse")
                                        .foregroundColor(Color.black)
                                    Picker("", selection: $category) {
                                                ForEach(["อาหารและเครื่องดื่ม","ท่องเที่ยว","ช้อปปิ้ง","ครอบครัวและเด็ก", "บ้านและการตกแต่ง","การ์ตูนและเกม","การพัฒนาตนเอง","การศึกษา","ทศกาลและประเพณี","รถยนต์และยานพาหนะ","แฟชั่น","การเงินและธนาคาร","ไอทีและเทคโนโลยี","สุขภาพและความงาม","ดนตรีและการแสดง","พืชและสัตว์","เพื่อสังคม","งานและอาชีพ","อุตสาหกรรม","แต่งงาน","ศิลปะและการออกแบบ","กีฬาและสันทนาการ","หนังสือ","ธุรกิจ"], id: \.self) {
                                                    Text("\($0)")
                                                }
                                    }.pickerStyle(WheelPickerStyle())
                                    .foregroundColor(Color.black)
                                    
                                }.padding(.horizontal, 2)
                                .frame(height: 50, alignment: .center)
                                //.background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        
                        VStack(alignment: .leading){
                            VStack{
                                Text("จำนวนผู้เข้าร่วมอีเว้นท์ (ที่นั่ง)")
                                    .foregroundColor(Color.black)
                            }
                                HStack{
                                    Image(systemName: "person.circle")
                                        .foregroundColor(Color.black)
                                    TextField("กรอกจำนวน", text: $numpeople)
                                        .foregroundColor(Color.black)
                                        .keyboardType(.numberPad)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
         
                        }.padding(.horizontal, 15)
                        
                        VStack(alignment: .leading){
                            VStack{
                                Text("รูปแบบการจัดงาน")
                                    .foregroundColor(Color.black)
                            }
                            HStack(spacing: 15){
                                Picker(formatEvent, selection: $formatEvent) {
                                            ForEach(["ออนไลน์","ออฟไลน์"], id: \.self) {
                                                Text("\($0)")
                                            }
                                }.pickerStyle(SegmentedPickerStyle())
                                .foregroundColor(Color.black)
                                
                            }.padding(.vertical, 10)
                                
         
                        }.padding(.horizontal, 15)
                        
                        VStack(alignment: .leading){
                            VStack{
                                Text("สถานที่จัดอีเว้นท์")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "person.circle")
                                        .foregroundColor(Color.black)
                                    TextField("กรอกชื่อ", text: $location)
                                        .foregroundColor(Color.black)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        
                        VStack(alignment: .leading){
                            VStack{
                                Text("จังหวัดที่จัดอีเว้นท์")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    Image(systemName: "mappin.and.ellipse")
                                        .foregroundColor(Color.black)
                                    Picker("", selection: $provinceEvent) {
                                                ForEach(["ไม่ระบุ","กระบี่","กรุงเทพมหานคร","กาญจนบุรี","กาฬสินธุ์","กำแพงเพชร","ขอนแก่น","จันทบุรี","ฉะเชิงเทรา" ,"ชลบุรี","ชัยนาท","ชัยภูมิ","ชุมพร","เชียงราย","เชียงใหม่","ตรัง","ตราด","ตาก","นครนายก","นครปฐม","นครพนม","นครราชสีมา" ,"นครศรีธรรมราช","นครสวรรค์","นนทบุรี","นราธิวาส","น่าน","บุรีรัมย์","ปทุมธานี","ประจวบคีรีขันธ์","ปราจีนบุรี","ปัตตานี" ,"พะเยา","พังงา","พัทลุง","พิจิตร","พิษณุโลก","เพชรบุรี","เพชรบูรณ์","แพร่","ภูเก็ต","มหาสารคาม","มุกดาหาร","แม่ฮ่องสอน" ,"ยโสธร","ยะลา","ร้อยเอ็ด","ระนอง","ระยอง","ราชบุรี","ลพบุรี","ลำปาง","ลำพูน","เลย","ศรีสะเกษ","สกลนคร","สงขลา" ,"สตูล","สมุทรปราการ","สมุทรสงคราม","สมุทรสาคร","สระแก้ว","สระบุรี","สิงห์บุรี","สุโขทัย","สุพรรณบุรี","สุราษฎร์ธานี" ,"สุรินทร์","หนองคาย","หนองบัวลำภู","อยุธยา","อ่างทอง","อำนาจเจริญ","อุดรธานี","อุตรดิตถ์","อุทัยธานี","อุบลราชธานี"], id: \.self) {
                                                    Text("\($0)")
                                                }
                                    }.pickerStyle(WheelPickerStyle())
                                    .foregroundColor(Color.black)
                                    
                                }.padding(.horizontal, 2)
                                .frame(height: 50, alignment: .center)
                                //.background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        
                        VStack(alignment: .leading){
                            VStack{
                                Text("รายละเอียดอีเว้นท์")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "tray")
                                        .foregroundColor(Color.black)
                                    
                                    TextEditor(text: $detail)
                                        .cornerRadius(10)
                                        .colorMultiply(Color.white)
                                        .background(Color.white)
                                        .foregroundColor(Color.black)
                                        
                                    
                                }
                                .frame(height: 100)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        
                    }.padding(.vertical)
                    .background(Color.newECECEC)
                    .cornerRadius(10)
                    //end
                    
                    
                    Text("วันที่และเวลาที่จัดอีเว้นท์")
                        .font(Font.custom("Bebas Neue", size: 24))
                        .padding(5)
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            HStack(spacing: 15){
                                Image(systemName: "calendar.circle.fill")
                                    .foregroundColor(Color.black)
                                DatePicker("วันที่เริ่มอีเว้นท์ \(dateStart)", selection: $DateStart, displayedComponents: .date)
                                     //.pickerStyle(WheelPickerStyle())
                                    .foregroundColor(Color.black)
                                    .onChange(of: DateStart, perform: { value in
                                        let convert = DateFormatter()
                                            
                                        convert.dateFormat = "dd/MM/YYYY"
                                            
                                        self.dateStart = "\(convert.string(from: DateStart))"
                                    })
                            }
         
                        }.padding(.horizontal, 15)
                        VStack(alignment: .leading){
                            HStack(spacing: 15){
                                Image(systemName: "calendar.circle.fill")
                                    .foregroundColor(Color.black)
                                DatePicker("วันที่สิ้นสุดอีเว้นท์ \(dateEnd)", selection: $DateEnd, displayedComponents: .date)
                                     //.pickerStyle(WheelPickerStyle())
                                    .foregroundColor(Color.black)
                                    .onChange(of: DateEnd, perform: { value in
                                        let convert2 = DateFormatter()
                                            
                                        convert2.dateFormat = "dd/MM/YYYY"
                                            
                                        self.dateEnd = "\(convert2.string(from: DateEnd))"
                                    })

                            }
         
                        }.padding(.horizontal, 15)
                        VStack(alignment: .leading){
                            HStack(spacing: 15){
                                Image(systemName: "calendar.circle.fill")
                                    .foregroundColor(Color.black)
                                DatePicker("เวลาที่เริ่มอีเว้นท์ \(timeStart)", selection: $TimeStart, displayedComponents: .hourAndMinute)
                                     //.pickerStyle(WheelPickerStyle())
                                    .foregroundColor(Color.black)
                                    .onChange(of: TimeStart, perform: { value in
                                        let convert3 = DateFormatter()
                                        
                                        convert3.dateFormat = "HH:mm"
                                        
                                        self.timeStart = "\(convert3.string(from: TimeStart))"
                                    })
  
                            }
         
                        }.padding(.horizontal, 15)
                        VStack(alignment: .leading){
                            HStack(spacing: 15){
                                Image(systemName: "calendar.circle.fill")
                                    .foregroundColor(Color.black)
                                DatePicker("เวลาที่สิ้นสุดอีเว้นท์ \(timeEnd)", selection: $TimeEnd, displayedComponents: .hourAndMinute)
                                     //.pickerStyle(WheelPickerStyle())
                                    .foregroundColor(Color.black)
                                    .onChange(of: TimeEnd, perform: { value in
                                        let convert4 = DateFormatter()
                                        
                                        convert4.dateFormat = "HH:mm"
                                        
                                        self.timeEnd = "\(convert4.string(from: TimeEnd))"
                                    })

                            }
         
                        }.padding(.horizontal, 15)
                        
                        
                    }.padding(.vertical)
                    .background(Color.newECECEC)
                    .cornerRadius(10)
                    //end
                    
                    
                    Text("ข้อมูลที่ทำงาน")
                        .font(Font.custom("Bebas Neue", size: 24))
                        .padding(5)
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            VStack{
                                Text("บริษัทหรือหน่วยงาน(ถ้ามี)")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "tray")
                                        .foregroundColor(Color.black)
                                    TextField("ระบุบริษัทหรือหน่วยงาน", text: $nameCompany)
                                        .foregroundColor(Color.black)
                                    
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        VStack(alignment: .leading){
                            VStack{
                                Text("ที่อยู่บริษัทหรือหน่วยงาน")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "tray")
                                        .foregroundColor(Color.black)
                                    TextField("ระบุที่อยู่", text: $addressCompany)
                                        .foregroundColor(Color.black)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                    }.padding(.vertical)
                    .background(Color.newECECEC)
                    .cornerRadius(10)
                    //end
                    
                    
                    Text("การติดต่อ")
                        .font(Font.custom("Bebas Neue", size: 24))
                        .padding(5)
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            VStack{
                                Text("เว็บไซต์(ถ้ามี)")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "tray")
                                        .foregroundColor(Color.black)
                                    TextField("Copylink", text: $webSite)
                                        .foregroundColor(Color.black)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        VStack(alignment: .leading){
                            VStack{
                                Text("เบอร์โทรศัพท์(ถ้ามี)")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "tray")
                                        .foregroundColor(Color.black)
                                    TextField(" กรอกเบอร์โทรศัพท์", text: $tel)
                                        .foregroundColor(Color.black)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        VStack(alignment: .leading){
                            VStack{
                                Text("อีเมล(ถ้ามี)")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "tray")
                                        .foregroundColor(Color.black)
                                    TextField("กรอกอีเมล", text: $email)
                                        .foregroundColor(Color.black)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        .onAppear{
                            self.email = user?.email ?? ""
                        }
                        VStack(alignment: .leading){
                            VStack{
                                Text("Facebook(ถ้ามี)")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "tray")
                                        .foregroundColor(Color.black)
                                    TextField("ระบุชื่อ facebook", text: $facebook)
                                        .foregroundColor(Color.black)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        VStack(alignment: .leading){
                            VStack{
                                Text("Twitter(ถ้ามี)")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "tray")
                                        .foregroundColor(Color.black)
                                    TextField("ระบุชื่อบัญชี", text: $twitter)
                                        .foregroundColor(Color.black)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        VStack(alignment: .leading){
                            VStack{
                                Text("Instagram(ถ้ามี)")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "tray")
                                        .foregroundColor(Color.black)
                                    TextField("ระบุชื่อบัญชี", text: $instagram)
                                        .foregroundColor(Color.black)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        VStack(alignment: .leading){
                            VStack{
                                Text("Youtube(ถ้ามี)")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "tray")
                                        .foregroundColor(Color.black)
                                    TextField("ระบุชื่อช่อง", text: $youtube)
                                        .foregroundColor(Color.black)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                    }.padding(.vertical)
                    .background(Color.newECECEC)
                    .cornerRadius(10)
                    //end
                    
                }.padding(.horizontal, 10)
                HStack {
                        Button(action: {
                            
                            let docData: [String: Any] = [
                                "title" : "\(title)",
                                "email":"\(email)",
                                "addressCompany":"\(addressCompany)",
                                "dateEnd":"\(dateEnd)",
                                "dateStart" : "\(dateStart)",
                                "category" : "\(category)",
                                "tel":"\(tel)",
                                "detail": "\(detail)",
                                "formatEvent" : "\(formatEvent)",
                                "location" : "\(location)",
                                "nameCopany" : "\(nameCompany)",
                                "facebook" : "\(facebook)",
                                "instagram" : "\(instagram)",
                                "numpeople" : "\(numpeople)",
                                "provinceUser" : "\(provinceEvent)",
                                "provinceEvent" : "\(provinceEvent)",
                                "twitter" : "\(twitter)",
                                "webSite" : "\(webSite)",
                                "youtube" : "\(youtube)",
                                "nameCompany" : "\(nameCompany)",
                                "timeEnd" : "\(timeEnd)",
                                "timeStart" : "\(timeStart)"
                            ]
                            
                            db.collection("Events").document(eventDetail.id).updateData(docData) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
//                                    alert.toggle()
//                                    alertMsg = "\(err)"
                                } else {
                                    storageManagerEvent.upload(image: image,path:"BannerID-\(eventDetail.id)")
                                    print("Document successfully written!")
                                    self.getEditView.toggle()
                                }
                            }
                            

                        }) {
                                        
                                        Text("บันทึก")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .padding(.vertical)
                                            .frame(width: UIScreen.main.bounds.width/2)
                                        
                                    }.background(
    
                                        LinearGradient(gradient: .init(colors: [Color.blue]), startPoint: .leading, endPoint: .trailing)
                                    )
                                    .cornerRadius(8)
                                    //.offset(y: -40)
                                    //.padding(.bottom, -40)
                                    .shadow(radius: 15)
                                    
                    
                    
                }
//                .alert(isPresented: self.$alert) {
//                    Alert(title: Text("แจ้งเตือน"), message: Text(alertMsg), dismissButton: .default(Text("ตกลง")))
//                }
            }.onAppear{
                //setProfile()
                UITextView.appearance().backgroundColor = .clear
                
                self.addressCompany = eventDetail.addressCompany
                self.category = eventDetail.category
                self.dateStart = eventDetail.datestart
                self.dateEnd = eventDetail.dateend
                self.email = eventDetail.email
                self.detail = eventDetail.detail
                self.eventID = eventDetail.facebook
                self.formatEvent = eventDetail.formatEvent
                self.location = eventDetail.location
                self.nameCompany = eventDetail.nameCompany
                self.numpeople = String(eventDetail.numpeople)
                self.provinceEvent = eventDetail.provinceEvent
                self.title = eventDetail.title
                self.timeStart = eventDetail.timeStart
                self.timeEnd = eventDetail.timeEnd
                self.facebook = eventDetail.facebook
                self.instagram = eventDetail.instagram
                self.twitter = eventDetail.twitter
                self.webSite = eventDetail.webSite
                self.youtube = eventDetail.youtube
                self.tel = eventDetail.tel
                
                
            }
            .navigationTitle("Create Event")
            .toolbar{
                VStack(alignment: .leading, spacing: 10.0) {
                Button(action: {
                    self.getEditView.toggle()
                }, label: {
                    Image(systemName: "clear.fill")
                        .font(Font.custom("Bebas Neue", size: 40))
                        //.foregroundColor(.white)
                })
                }
            }
            
        }
                
    }
    
    
    
}

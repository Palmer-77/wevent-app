//
//  r.swift
//  Wevent V.1
//
//  Created by Palm on 22/4/2564 BE.
//
import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseFirestore

struct RegisterView: View {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    var storageManager = StorageManager()
    
    @AppStorage("log_status") var log_Status = false
    @AppStorage("log_data") var log_data = false
    @AppStorage("log_login") var log_login = false
    @AppStorage("log_user") var log_user = false
    
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
        
        NavigationView{
            ScrollView{
                ZStack {
                    Image(uiImage: self.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(50)
                        .frame(width: 150, height: 150)
                        .background(Color.black.opacity(0.2))
                        .clipShape(Circle())

                    Image(systemName: "camera.circle.fill")
                        .font(Font.custom("Bebas Neue", size: 30))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .onTapGesture {
                           showSheet = true
                        }
                        .onChange(of: image, perform: { image in
                            storageManager.upload(image: image,path:"ProfileID-\(user!.uid)")
                        })
                }
                .padding(.horizontal, 20)
                .sheet(isPresented: $showSheet) {
                            // Pick an image from the photo library:
                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)

                            //  If you wish to take a photo from camera instead:
                            ImagePicker(sourceType: .camera, selectedImage: self.$image)
                    }
                
                VStack(alignment: .leading) {
                    Text("ข้อมูลผู้ใช้")
                        .font(Font.custom("Bebas Neue", size: 24))
                        .padding(5)
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            VStack{
                                Text("ชื่อ")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "person.circle")
                                        .foregroundColor(Color.black)
                                    TextField("กรอกชื่อ", text: $name)
                                        .foregroundColor(Color.black)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        VStack(alignment: .leading){
                            VStack{
                                Text("นามสกุล")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "person.circle")
                                        .foregroundColor(Color.black)
                                    TextField("กรอกนามสกุล", text: $lastname)
                                        .foregroundColor(Color.black)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        
                        VStack(alignment: .leading){
                            VStack{
                                Text("เพศ")
                                    .foregroundColor(Color.black)
                            }
                            HStack(spacing: 15){
                                
                                Image(systemName: "person.fill.questionmark")
                                    .foregroundColor(Color.black)
                                Picker("", selection: $sex) {
                                            ForEach(["ชาย","หญิง"], id: \.self) {
                                                Text("\($0)")
                                            }
                                }.pickerStyle(SegmentedPickerStyle())
                                .foregroundColor(Color.black)
                            }.padding(.vertical, 10)
                                
         
                        }.padding(.horizontal, 15)
                        
                        VStack(alignment: .leading){
                            VStack{
                                Text("วัน/เดือน/ปี เกิด")
                                    .foregroundColor(Color.black)
                            }
                            HStack(spacing: 15){
                                Image(systemName: "calendar.circle.fill")
                                    .foregroundColor(Color.black)
                                DatePicker("", selection: $date, displayedComponents: .date)
                                     .pickerStyle(WheelPickerStyle())
                                    .foregroundColor(Color.black)
                            }
         
                        }.padding(.horizontal, 15)
                        
                        VStack(alignment: .leading){
                            VStack{
                                Text("อีเมลที่สามารถติดต่อได้")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "tray")
                                        .foregroundColor(Color.black)
                                    TextField("กรอกemail", text: $email)
                                        .foregroundColor(Color.black)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        .onAppear{
                            self.email = "\(user?.email ?? "")"
                        }
                        
                        VStack(alignment: .leading){
                            VStack{
                                Text("อีเมลอื่นๆ(ถ้ามี)")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "tray")
                                        .foregroundColor(Color.black)
                                    TextField("กรอกemail", text: $emailOther)
                                        .foregroundColor(Color.black)
                                }.padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        
                        VStack(alignment: .leading){
                            VStack{
                                Text("เบอร์โทรศัพท์ที่สามารถติดต่อได้")
                                    .foregroundColor(Color.black)
                                    
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "tray")
                                        .foregroundColor(Color.black)
                                    
                                    TextField("กรอกเบอร์", text: $tel)
                                        .foregroundColor(Color.black)
                                        .textContentType(.oneTimeCode)
                                        .keyboardType(.numberPad)
                                    
                                }
                                .padding()
                                .frame(height: 40, alignment: .center)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2.5)
         
                        }.padding(.horizontal, 15)
                        
                    }.padding(.vertical)
                    .background(Color.newECECEC)
                    .cornerRadius(10)
                    //end
                    
                    Text("ข้อมูลที่อยู่")
                        .font(Font.custom("Bebas Neue", size: 24))
                        .padding(5)
                    VStack(alignment: .leading){
                        VStack(alignment: .leading){
                            VStack{
                                Text("ที่อยู่ที่สามารถติดต่อได้")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    
                                    Image(systemName: "tray")
                                        .foregroundColor(Color.black)
                                    
                                    TextEditor(text: $addressUser)
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
                        VStack(alignment: .leading){
                            VStack{
                                Text("จังหวัด")
                                    .foregroundColor(Color.black)
                            }
                                HStack(spacing: 15){
                                    Image(systemName: "mappin.and.ellipse")
                                        .foregroundColor(Color.black)
                                    Picker("", selection: $provinceUser) {
                                                ForEach(proVince, id: \.self) {
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
                    
                    Text("สังคมออนไลน์")
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
                    
                    Toggle(isOn: $checked, label: {
                        Text("ยอมรับ")
                        Button(action: {
                            self.show.toggle()
                            
                        }) {
                            
                           Text("เงื่อนไข")
                            
                        }
                    }).padding()
                }
                .sheet(isPresented: $show) {
                    RuleView(show: self.$show)
                }
                .padding(.horizontal, 20)
                
        
                
                            
            
        
                HStack {
                    if checked {
                        Button(action: {
                            
                            setBirthday()
                            
                            let docData: [String: Any] = [
                                "id":user?.uid ?? "",
                                "email":"\(email)",
                                "name":"\(name)",
                                "lastName":"\(lastname)",
                                "sex" : "\(sex)",
                                "birthday" : "\(birthday)",
                                "tel":"\(tel)",
                                "rule": "ยอมรับ",
                                "organizer" : false ,
                                "emailOther" : "\(emailOther)",
                                "addressCompany" : addressCompany,
                                "addressUser" : addressUser,
                                "categoryEvent" : [],
                                "facebook" : facebook,
                                "instagram" : instagram,
                                "nameCompany" : nameCompany,
                                "provinceUser" : provinceUser,
                                "twitter" : twitter,
                                "webSite" : webSite,
                                "youtube" : youtube,
                                "user" : true,
                                "timeStamp" : FieldValue.serverTimestamp()
                            ]
                            
                            
                            db.collection("Users").document(user?.uid ?? "").setData(docData) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                } else {
                                    print("Document successfully written!")
                                    self.log_Status = true
                                    self.log_data = false
                                    self.log_user = true
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
                    else {
                        Button(action: {}) {
                                        
                                        Text("บันทึก")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .padding(.vertical)
                                            .frame(width: UIScreen.main.bounds.width/2)
                                        
                                    }.background(
                                    
                                        LinearGradient(gradient: .init(colors: [Color.gray]), startPoint: .leading, endPoint: .trailing)
                                    )
                                    .cornerRadius(8)
                                    //.offset(y: -40)
                                    //.padding(.bottom, -40)
                                    .shadow(radius: 15)
                    }
                }
//                .alert(isPresented: self.$alert) {
//                    Alert(title: Text("แจ้งเตือน"), message: Text(alertMsg), dismissButton: .default(Text("ตกลง")))
//                }
            }
            .navigationTitle("Create a New Profile")
            
        }
        
        VStack{
            Button(action: {

                try! Auth.auth().signOut()
                GIDSignIn.sharedInstance()?.signOut()
                UserDefaults.standard.set(false, forKey: "log_status")
                UserDefaults.standard.set(true, forKey: "log_data")
                UserDefaults.standard.set(false, forKey: "log_login")
            }) {

                Text("ออกจากระบบ")
            }
        }
        
    }
    
    
    func setBirthday(){
        let convert = DateFormatter()
        
        convert.dateFormat = "dd/MM/YYYY"
        
        self.birthday = "\(convert.string(from: date))"
        
        
    }
        

        
  
}



struct r_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(UserModel())
    }
}

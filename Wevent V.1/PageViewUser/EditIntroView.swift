//
//  EditIntroView.swift
//  Wevent V.1
//
//  Created by Palm on 7/5/2564 BE.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import CodeScanner
import GoogleSignIn


struct EditIntroView: View {
    @Binding var editIntroShow: Bool
    let user = Auth.auth().currentUser
    
    let db = Firestore.firestore()
    
    @State var Categorys : [String] = ["อาหารและเครื่องดื่ม","ท่องเที่ยว","ช้อปปิ้ง","ครอบครัวและเด็ก", "บ้านและการตกแต่ง","การ์ตูนและเกม","การพัฒนาตนเอง","การศึกษา","ทศกาลและประเพณี","รถยนต์และยานพาหนะ","แฟชั่น","การเงินและธนาคาร","ไอทีและเทคโนโลยี","สุขภาพและความงาม","ดนตรีและการแสดง","พืชและสัตว์","เพื่อสังคม","งานและอาชีพ","อุตสาหกรรม","แต่งงาน","ศิลปะและการออกแบบ","กีฬาและสันทนาการ","หนังสือ","ธุรกิจ"]
    @State var CategorysIcon : [String] = ["pencil","pencil.circle","square.and.pencil","star.fill", "house.fill","gamecontroller.fill","rectangle.expand.vertical","textformat.abc.dottedunderline","sunrise.fill","car.fill","applewatch.watchface","dollarsign.circle.fill","display.2","mouth.fill","face.smiling.fill","tornadoว์","person.3.fill","hand.point.up.braille.fill","hand.point.up.braille.fill","person.2","music.quarternote.3","sportscourt.fill","book.circle.fill","signature"]
    
    var columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 1)
    
    @Namespace var namespace
    
    @State var selectFFB : [String] = []

    @State var low1 = 0
    
    var body: some View {
            VStack{
                
                
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10.0) {
                            Text("Event Category")
                                .font(Font.custom("Bebas Neue", size: 40))
                        }
                        
                        //.foregroundColor(.black)
                        Spacer(minLength:0)
                        
                        VStack{
                                Image(systemName: "xmark.circle")
                                    .font(Font.custom("Bebas Neue", size: 30))
                            }
                            .onTapGesture {
                                self.editIntroShow.toggle()
                            }
                    }
                    
                }.padding(.horizontal, 10)
                .padding(.bottom, 1)
                
                Text("เลือกหมวดอีเว้นท์ที่คุณสนใจ")
                    .font(.title3)
                    .bold()
                Text("เลือกหมวดอีเว้นท์อย่างน้อย 3 หมวด")
                    .font(.body)
                
                Text("จำนวนที่เลือก \(selectFFB.count) หมวด")
                ScrollView{
                    LazyVGrid(columns: columns,spacing:5 ){
                            ForEach(self.Categorys, id: \.self) { item in
                                MultipleSelectionRow(title: item ,isSelected: self.selectFFB.contains(item), icon: CategorysIcon[low1]) {
                                                if self.selectFFB.contains(item) {
                                                    self.selectFFB.removeAll(where: { $0 == item })
                                                    
                                                }
                                                else {
                                                    self.selectFFB.append(item)
                                                    
                                                }
                                            }
                                
                                        }
                    }.padding(.all)
                }
                VStack {
                    Button(action: {
                        db.collection("Users").document(user!.uid).updateData([
                            "categoryEvent" : selectFFB
                        ])
                        self.editIntroShow.toggle()
                    }){
                        HStack{
                            
                            Image(systemName: "arrow.counterclockwise.icloud")
                            Text("บันทึก")
                                
                        }.padding(.vertical)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(Color.red)
                        .cornerRadius(10)
                        
                    }
                }.padding(.bottom,5)
                
                
                
            }.onAppear{
                reCheck()
            }
        .animation(.easeOut)
    }
    
    func reCheck () {


        db.collection("Users").document("\(user?.uid ?? "")").addSnapshotListener {(document, error) in
            
            //print("test \(document!.data()!["categoryEvent"])")
            self.selectFFB = document!.data()!["categoryEvent"] as! [String]
            print(self.selectFFB)
        }
        
        
    }

    
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var icon: String
    var action: () -> Void
    

    var body: some View {
        Button(action: self.action) {
                if self.isSelected {
                    HStack {
                        Image(systemName: "1.circle")
                            .padding()
                        Text(self.title)
                            .font(Font.system(size: 18))
                            Spacer()
                    }.foregroundColor(.black)
                    //.fontWeight(.bold)
                    //.frame(width: UIScreen.main.bounds.width - 50)
                    .background(Color.gray)
                    .padding(.horizontal,10)
                    .cornerRadius(10)
                }
                else{
                    HStack {
                        Image(systemName: "0.circle")
                            
                            .padding()
                        Text(self.title)
                            .font(Font.system(size: 18))
                        Spacer()
                    }.foregroundColor(.black)
                    //.fontWeight(.bold)
                    //.frame(width: UIScreen.main.bounds.width - 50)
                    .background(Color.white)
                    .padding(.horizontal,10)
                    .cornerRadius(10)
                    
                }
                
                
            
        }
    }
}

//struct EditIntroView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditIntroView()
//    }
//}


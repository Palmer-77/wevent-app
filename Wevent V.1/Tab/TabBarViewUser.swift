//
//  TabBarViewUser.swift
//  Wevent V.1
//
//  Created by Palm on 2/5/2564 BE.
//

import SwiftUI

struct TabBarViewUser: View {
    @Binding var selectionUser: Int
    @Namespace private var currentTabUser
    
    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(tabsUser.indices){ index in
                GeometryReader { geometry in
                    VStack(spacing: 6){
                        if selectionUser == index {
                            Color(.label)
                                .frame(height: 3)
                                .offset(y: -4)
                                .matchedGeometryEffect(id: "currentTabUser", in: currentTabUser)
                        }
                        if tabsUser[selectionUser].label == "Notifications" && tabsUser[index].label == "Notifications" {
                            Image(systemName: tabsUser[index].image)
                                .frame(height: 20)
                                .rotationEffect(.degrees(25))
                        }
                        else {
                            Image(systemName: tabsUser[index].image)
                                .frame(height: 20)
                                .rotationEffect(.degrees(0))
                        }
                        Text(tabsUser[index].label)
                            .font(.caption2)
                            .fixedSize()
                        
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: geometry.size.width/2,height: 44, alignment: .bottom)
                    .padding(.horizontal)
                    .foregroundColor(selectionUser == index ? Color(.label) : .secondary)
                    .onTapGesture {
                        withAnimation {
                            selectionUser = index
                        }
                    }
                }
                .frame(height: 44, alignment: .bottom)
            }
        }
    }
}

struct TabBarViewUser_Previews: PreviewProvider {
    static var previews: some View {
        TabBarViewUser(selectionUser: Binding.constant(0))
            .previewLayout(.sizeThatFits)
    }
}

struct TabUser {
    let image: String
    let label: String
}

let tabsUser = [
    TabUser(image: "house.fill", label: "หน้าแรก"),
    TabUser(image: "magnifyingglass", label: "ค้นหา"),
    TabUser(image: "globe", label: "ฟีด"),
    TabUser(image: "person.fill", label: "โปรไฟล์"),
    TabUser(image: "gearshape.fill", label: "ตั้งค่า")
]

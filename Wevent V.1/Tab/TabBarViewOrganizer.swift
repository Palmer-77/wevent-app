//
//  TabBarView.swift
//  Wevent V.swift ui
//
//  Created by BlackStar on 9/3/2564 BE.
//

import SwiftUI

struct TabBarViewOrganizer: View {
    @Binding var selection: Int
    @Namespace private var currentTab
    
    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(tabs.indices){ index in
                GeometryReader { geometry in
                    VStack(spacing: 6){
                        if selection == index {
                            Color(.label)
                                .frame(height: 3)
                                .offset(y: -4)
                                .matchedGeometryEffect(id: "currentTab", in: currentTab)
                        }
                        if tabs[selection].label == "Notifications" && tabs[index].label == "Notifications" {
                            Image(systemName: tabs[index].image)
                                .frame(height: 20)
                                .rotationEffect(.degrees(25))
                        }
                        else {
                            Image(systemName: tabs[index].image)
                                .frame(height: 20)
                                .rotationEffect(.degrees(0))
                        }
                        Text(tabs[index].label)
                            .font(.caption2)
                            .fixedSize()
                        
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: geometry.size.width/2,height: 44, alignment: .bottom)
                    .padding(.horizontal)
                    .foregroundColor(selection == index ? Color(.label) : .secondary)
                    .onTapGesture {
                        withAnimation {
                            selection = index
                        }
                    }
                }
                .frame(height: 44, alignment: .bottom)
            }
        }
    }
}

struct TabBarViewOrganizer_Previews: PreviewProvider {
    static var previews: some View {
        TabBarViewOrganizer(selection: Binding.constant(0))
            .previewLayout(.sizeThatFits)
    }
}

struct Tab {
    let image: String
    let label: String
}

let tabs = [
    Tab(image: "house.fill", label: "หน้าแรก"),
    Tab(image: "briefcase.fill", label: "จัดการอีเว้นท์"),
    Tab(image: "square.and.pencil", label: "สร้าง"),
    Tab(image: "person.fill", label: "โปรไฟล์"),
    Tab(image: "gearshape.fill", label: "ตั้งค่า")
]



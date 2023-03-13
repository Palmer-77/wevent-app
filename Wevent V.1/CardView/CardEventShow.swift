//
//  CardEventShow.swift
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

struct CardEventShow: View {
    
    var eventDetail : EventModel
    @State var urlEvent : String
    
    var body: some View {
        VStack{
            HStack{
                AnimatedImage(url: URL(string: urlEvent)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 85 , height: 85, alignment: .center)
                    .cornerRadius(5)
                    .padding(5)
                
                VStack{
                    HStack{
                        Text("\(eventDetail.category)")
                            .font(.caption)
                        Spacer()
                    }
                    HStack{
                        Text("\(eventDetail.title)")
                            .font(.title3)
                            .bold()
                            .lineLimit(2)
                        Spacer()
                    }
                    HStack{
                        Image(systemName: "calendar")
                            .font(.caption)
                        Text("\(eventDetail.datestart) - \(eventDetail.dateend)")
                            .font(.caption)
                        Spacer()
                    }
                    HStack{
                        Image(systemName: "mappin.circle.fill")
                            .font(.caption)
                        Text("\(eventDetail.timeStart) - \(eventDetail.timeEnd)")
                            .font(.caption)
                        Spacer()
                    }
                    
                }.padding(5)
                Spacer()
            }.padding(5)
        }.background(Color.white)
        .frame(height: 110, alignment: .center)
        .cornerRadius(10)
        .padding(.horizontal,10)

    }
    

    
    
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

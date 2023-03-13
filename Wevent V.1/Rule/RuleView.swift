//
//  RuleView.swift
//  Wevent V.1
//
//  Created by Palm on 27/4/2564 BE.
//

import SwiftUI

struct RuleView: View {
    @Binding var show : Bool
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button(action: {
            
            self.show.toggle()
            
        }) {
            
           Text("เสร็จ")
            
        }
    }
}

//struct RuleView_Previews: PreviewProvider {
//    static var previews: some View {
//        RuleView()
//    }
//}

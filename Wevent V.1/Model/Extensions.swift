//
//  Extensions.swift
//  Wevent V.1
//
//  Created by Palm on 1/5/2564 BE.
//

import SwiftUI

extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

extension Color {
    static let oldGreenK = Color(UIColor.systemIndigo)
    static let newGreenK = Color("greenK")
    static let oldGreenSky = Color(UIColor.systemIndigo)
    static let newGreenSky = Color("greensky")
    static let old413C69 = Color(UIColor.systemIndigo)
    static let new413C69 = Color("413C69")
    static let oldbg = Color(UIColor.systemIndigo)
    static let bg = Color("bg")
    static let oldECECEC = Color(UIColor.systemIndigo)
    static let newECECEC = Color("ECECEC")
}

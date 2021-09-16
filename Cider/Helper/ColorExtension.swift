//
//  ColorExtension.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/20.
//

import SwiftUI

extension Color: Codable {
    var accessibleFontColor: Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: nil)
        return isLightColor(red: red, green: green, blue: blue) ? .black : .white
    }
    
    private func isLightColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> Bool {
        let lightRed = red > 0.65
        let lightGreen = green > 0.65
        let lightBlue = blue > 0.65

        let lightness = [lightRed, lightGreen, lightBlue].reduce(0) { $1 ? $0 + 1 : $0 }
        return lightness >= 2
    }
    
    var rgbValues:(red: Double, green: Double, blue: Double){
        let rgba = UIColor(self).rgba
        return (rgba.red, rgba.green, rgba.blue)
    }
    
    enum CodingKeys: String, CodingKey {
        case red
        case green
        case blue
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let red = try values.decode(Double.self, forKey: .red)
        let green = try values.decode(Double.self, forKey: .green)
        let blue = try values.decode(Double.self, forKey: .blue)
        self.init(red: red, green: green, blue: blue)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let rgba = self.rgbValues
        try container.encode(rgba.red, forKey: .red)
        try container.encode(rgba.green, forKey: .green)
        try container.encode(rgba.blue, forKey: .blue)
    }
}

extension UIColor {
    var rgba: (red: Double, green: Double, blue: Double, alpha: Double) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (Double(red), Double(green), Double(blue), Double(alpha))
    }
}

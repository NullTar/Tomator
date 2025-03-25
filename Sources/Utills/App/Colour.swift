//
//  Colour.swift
//  Tomator
//
//  Created by NullSilck on 2025/3/25.
//

import SwiftUICore

extension Color {
    init(hex: String) {
        var hexSanitized: String
        if hex.contains("#") {
            hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "#", with: "")
        } else {
            hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }

    func toHex() -> String {
        guard let components = self.cgColor?.components else {
            return "#000000"
        }

        if components.count >= 3 {
            // RGB 颜色
            let r = components[0]
            let g = components[1]
            let b = components[2]

            let red = Int(r * 255)
            let green = Int(g * 255)
            let blue = Int(b * 255)
            return String(format: "#%02X%02X%02X", red, green, blue)
        } else if components.count == 2 {
            // 灰度颜色（黑、白、灰）
            let white = components[0]
            let gray = Int(white * 255)
            return String(format: "#%02X%02X%02X", gray, gray, gray)
        }
        
        return "#000000"
    }

}

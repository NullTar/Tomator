//
//  LessMenuStyle.swift
//  TomatoBar
//
//  Created by NullSilck on 2025/3/13.
//

import SwiftUI


// 自定义 MenuStyle
struct LessMenuStyle: MenuStyle,Hashable {
    // 实现协议中的 makeBody(configuration:) 方法
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding(6)
    }
}

extension MenuStyle where Self == LessMenuStyle{
    
}


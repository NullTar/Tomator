//
//  ColorSetting.swift
//
//  Created by NullSilck on 2025/3/15.
//

import SwiftUI

struct ColorSetting: View {

    @EnvironmentObject var appSetter: AppSetter
    // 选择的数据
    @State private var selectedColor: String? = nil
    // 控制列
    let columns = Array(repeating: GridItem(.flexible()), count: 6)
    var body: some View {

        HStack {
            Text(NSLocalizedString("Color.accent.setting", comment: "颜色"))
                .fontWeight(.bold).font(.caption).frame(
                    maxWidth: .infinity, alignment: .leading
                )
                .foregroundColor(Color.gray).padding(.leading, 8)
            Circle().fill(Color(appSetter.appearance.color))
                .frame(width: 16)
                .overlay(
                    Circle()
                        .stroke(Color.secondary, lineWidth: 1.2)
                )
        }
        VStack {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Colors, id: \.self) { it in
                    Button(action: {
                        selectedColor = it.name
                    }) {
                        VStack {
                            Circle()
                                .fill(it.color)
                                .frame(width: 16, height: 16)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            Color.secondary, lineWidth: 1.2)
                                )
                            Text(it.name)
                                .font(.system(size: 8))
                                .foregroundColor(Color.gray)
                        }.frame(maxWidth: .infinity)
                    }.buttonStyle(BorderlessButtonStyle())
                        .onChange(of: selectedColor) { newValue in
                            if let newValue = newValue {
                                appSetter.appearance.color = newValue
                            }
                        }
                }
            }.padding(.vertical)

        }.background(Color("CardView")).cornerRadius(8).shadow(
            color: .gray.opacity(0.5), radius: 0.4)
    }
}

#Preview {
    AppearanceSetting()
        .environmentObject(AppSetter.shared)
        .frame(width: .infinity, height: .infinity)
}

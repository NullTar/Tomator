//
//  ColorSetting.swift
//
//  Created by NullSilck on 2025/3/15.
//

import SwiftUI

struct ColorSetting: View {

    @EnvironmentObject var appSetter: AppSetter
    // 控制列
    let columns = Array(repeating: GridItem(.flexible()), count: 6)
    var body: some View {

        HStack {
            Text(NSLocalizedString("Color.accent.setting", comment: "颜色"))
                .fontWeight(.bold).font(.caption).frame(
                    maxWidth: .infinity, alignment: .leading
                )
                .foregroundColor(Color.gray).padding(.leading, 8)
        }.padding(.top, 4)
        VStack {
            LazyVGrid(columns: columns, spacing: 16) {
                VStack{
                    ColorPicker("", selection: $appSetter.color)
                        .frame(width: 10, height: 10)
                        .clipShape(Circle())
                        .scaleEffect(2.12)
                        .labelsHidden()
                        .onChange(of: appSetter.color) { newValue in
                            appSetter.appearance.color = newValue.toHex()
                        }
                    Text(NSLocalizedString("Color.pick", comment: "选择颜色"))
                        .font(.system(size: 10))
                        .foregroundColor(Color.gray).padding(.top,2)
                }
                ForEach(Colors, id: \.self) { it in
                    Button(action: {
                        appSetter.appearance.color = it.name
                    }) {
                        VStack {
                            Circle()
                                .fill(it.color)
                                .frame(width: 20, height: 20)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            Color.secondary, lineWidth: 1.2)
                                )
                            Text(it.name)
                                .font(.system(size: 10))
                                .foregroundColor(Color.gray)
                        }.frame(maxWidth: .infinity)
                    }.buttonStyle(BorderlessButtonStyle())
                        .onChange(of: appSetter.appearance.color) { newValue in
                            appSetter.appearance.color = newValue
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

//
//  InfoConponet.swift
//
//  Created by NullSilck on 2025/3/14.
//

import SwiftUI

// info
struct InfoConponet: View {
    // 控制Popover的显示
    @State private var showPopover = false
    var label: String

    var body: some View {
        Image(systemName: "info.circle")
            .onHover { hovering in
                showPopover = hovering
            }
            .popover(isPresented: $showPopover) {
                Text(label)
                    .padding()
            }
    }
}

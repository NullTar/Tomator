//
//  WindowController.swift
//
//  Created by NullSilck on 2025/3/15.
//
import AppKit
import SwiftUI
class WindowProperties: ObservableObject {

    @Published var width: CGFloat {
        didSet {
            if width < 260 {
                width = 260
            }
        }
    }
    @Published var height: CGFloat {
        didSet {
            if height < 280 {
                height = 280
            }
        }
    }
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }

    func updateEdg(
        edg: WindowEdg, operation: WindowOperation, quantity: CGFloat
    ) {
        switch edg {
        case .width:
            switch operation {
            case .plus:
                width += quantity
            case .minus:
                width -= quantity
            }
        case .height:
            switch operation {
            case .plus:
                height += quantity
            case .minus:
                height -= quantity
            }
        }
    }
    
    func setUpFrame(width:CGFloat,height:CGFloat){
        self.width = width
        self.height = height
    }
    
}

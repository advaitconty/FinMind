//
//  AdaptiveLiquidGlassButtons.swift
//  Trial Manager
//
//  Created by Milind Contractor on 20/12/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func adaptiveProminentButtonStyle() -> some View {
        if #available(iOS 26.0, *) {
            self.buttonStyle(.glassProminent)
        } else {
            self.buttonStyle(.borderedProminent)
        }
    }
}

extension View {
    @ViewBuilder
    func adaptiveButtonStyle() -> some View {
        if #available(iOS 26.0, *) {
            self.buttonStyle(.glass)
        } else {
            self.buttonStyle(.bordered)
        }
    }
}

//
//  TCPIPButtonStyle.swift
//  TCPIPTester
//
//  Created by alphacircle on 11/27/25.
//

import SwiftUI

struct TCPIPButtonStyle: ButtonStyle {
    let size: CGFloat
    let disabled: Bool
    
    init(size: CGFloat, disabled: Bool = false) {
        self.size = size
        self.disabled = disabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.system(size: size, weight: .regular, design: .monospaced))
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8.0)
            .background(Color.BTN)
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
            .padding(.horizontal, 8.0)
            .colorMultiply(configuration.isPressed ? Color(white: 0.8) : Color.white)
            .colorMultiply(disabled ? Color(white: 0.5) : Color.white)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Button("TCP/IP") {
        
    }
    .buttonStyle(TCPIPButtonStyle(size: 32))
}

#Preview("Disable",traits: .sizeThatFitsLayout) {
    Button("TCP/IP") {
        
    }
    .buttonStyle(TCPIPButtonStyle(size: 32, disabled: true))
}

//
//  SettingScreen.swift
//  TCPIPTester
//
//  Created by alphacircle on 11/27/25.
//

import SwiftUI

struct SettingScreen: View {
    @Environment(AppState.self)
    private var appState
    
    var protocolType: Binding<ProtocolType> {
        Binding {
            appState.protocolType
        } set: { newValue, _ in
            appState.protocolType = newValue
        }
    }
    
    var role: Binding<Role> {
        Binding {
            appState.role
        } set: { newValue, _ in
            appState.role = newValue
        }
    }
    
    func startAction() {
        switch appState.role {
        case .client: appState.screen = .client
        case .server: appState.screen = .server
        }
    }

    var body: some View {
        _SettingScreen(protocolType: protocolType,
                       role: role,
                       startAction: startAction)
    }
}


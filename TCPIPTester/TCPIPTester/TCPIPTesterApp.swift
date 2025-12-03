//
//  TCPIPTesterApp.swift
//  TCPIPTester
//
//  Created by alphacircle on 11/26/25.
//

import SwiftUI

@Observable
final class AppState {
    var protocolType: ProtocolType = .tcp
    
    var role: Role = .client
    
    var screen: Screen = .setting

    enum Screen {
        case setting
        case client
        case server
    }
}

@main
struct TCPIPTesterApp: App {
    @State
    private var appState: AppState = AppState()
    
    var body: some Scene {
        WindowGroup {
            switch appState.screen {
            case .setting:
                SettingScreen()
                    .environment(appState)
            case .client:
                ClientScreen()
                    .environment(appState)
            case .server:
                ServerScreen()
                    .environment(appState)
            }
        }
        .windowResizability(.contentMinSize)
        .defaultSize(CGSize(width: 600, height: 450))
    }
}

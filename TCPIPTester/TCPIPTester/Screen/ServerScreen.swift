//
//  ServerScreen.swift
//  TCPIPTester
//
//  Created by alphacircle on 11/27/25.
//

import SwiftUI
import TCPIP
import Network

struct ServerScreen: View {
    @Environment(AppState.self)
    private var appState
    
    @State
    private var port: String = ""
    
    @State
    private var logs: [Log] = []
    
    @State
    var isConnected: Bool = false
    
    @State
    var server: TCPServer? = nil
    
    @State
    var serverListense: Task<Void, Never>? = nil
    
    func newLog(role: Role = .server, _ message: String) {
        logs.append(Log(id: logs.count + 1, role: role, message: message))
    }
    
    private func connect() {
        Task {
            do {
                let _port: UInt16 = UInt16(port) ?? 800
                self.newLog("Try to create a new server")
                let server = try TCPServer(port: _port, using: appState.protocolType.parameter)
                self.server = server
                self.newLog("server created(port: \(port))..")
                await self.server?.connect()
                self.newLog("server connect!")
                self.isConnected = true
                
                self.serverListense = Task {
                    for await state in await server.stateNotifier() {
                        switch state {
                        case .setup:
                            newLog("Server setup")
                        case .waiting(let nWError):
                            newLog("Server wating - \(nWError)")
                        case .ready:
                            newLog("Server ready ")
                        case .failed(let nWError):
                            newLog("Server fail \(nWError) ")
                        case .cancelled:
                            newLog("Server cancelled ")
                        @unknown default:
                            fatalError()
                        }
                    }
                }
            } catch {
                self.newLog("Fail to create server.")
            }
        }
    }
    
    private func disconnect() {
        Task {
            self.newLog("try to disconnect server...")
            await self.server?.disconnect()
            self.isConnected = false
            self.newLog("server has been disconnected.")
        }
    }
    
    private func back() {
        appState.screen = .setting
    }
    
    var body: some View {
        _ServerScreen(port: $port,
                      logs: logs,
                      isConnected: isConnected,
                      connect: connect,
                      disconnect: disconnect,
                      back: back)
    }
}

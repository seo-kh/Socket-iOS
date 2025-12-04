//
//  ClientScreen.swift
//  TCPIPTester
//
//  Created by alphacircle on 11/27/25.
//

import SwiftUI
import TCPIP
import Network

struct ClientScreen: View {
    @Environment(AppState.self)
    private var appState
    
    @State
    private var ipAddress: String = ""
    
    @State
    private var port: String = ""
    
    @State
    private var message: String = ""
    
    @State
    private var logs: [Log] = []
    
    @State
    private var isConnected: Bool = false
    
    @State
    private var client: TCPClient? = nil
    
    @State
    private var stateListen: Task<Void, Never>? = nil
    
    @AppStorage(URI.key)
    private var uri: URI = URI.empty

    private func connect() {
        let port: UInt16 = UInt16(port) ?? 4400
        self.newLog("try to create a client...")
        self.client = TCPClient(host: ipAddress, port: port, using: appState.protocolType.parameter)
        self.newLog("client has been made.!")
        self.newLog("try to connect to server")
        self.client?.connect(queue: DispatchQueue(label: "Client"))
        self.newLog("connected!!")
        self.isConnected = true
        
        guard let client else { return }
        self.stateListen = Task {
            for await state in client.stateNotifier() {
                switch state {
                case .setup:
                    self.newLog("client now setup")
                case .waiting(let nWError):
                    self.newLog("client now wating due \(nWError)")
                case .preparing:
                    self.newLog("client now preparing")
                case .ready:
                    self.newLog("client now ready")
                case .failed(let nWError):
                    self.newLog("client has not connected due \(nWError)")
                case .cancelled:
                    self.newLog("client has being cancelled")
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    
    private func newLog(role: Role = .client, _ message: String) {
        self.logs.append(Log(id: self.logs.count + 1, role: role, message: message))
    }

    private func disconnect() {
        self.client?.disconnect()
        self.isConnected = false
        self.newLog("disconnected")
    }
    
    private func send() {
        let postProcessed = message + "\n"
        guard let data = postProcessed.data(using: .utf8) else {
            self.logs.append(Log(id: self.logs.count + 1, role: .client, message: "message: \(message) has failed to encode to utf8 data."))
            return
        }
        Task {
            do {
                try await self.client?.send(data: data)
                guard let (data, _, _) = try await self.client?.receive() else {
                    self.logs.append(Log(id: self.logs.count + 1, role: .client, message: "connection has been cancelled."))
                    return
                }
                
                guard let serverData = data,
                      let response = String(data: serverData, encoding: .utf8) else {
                    self.logs.append(Log(id: self.logs.count + 1, role: .client, message: "server data is nil"))
                    return
                }
                
                self.logs.append(Log(id: self.logs.count + 1, role: .server, message: "response - \(response)"))
            } catch {
                print("communicate fail: \(error)")
            }
        }
    }
    
    private func back() {
        appState.screen = .setting
    }
    
    private func save() {
        uri.ip = ipAddress
        uri.port = port
    }
    
    var body: some View {
        _ClientScreen(ipAddress: $ipAddress,
                      port: $port,
                      message: $message,
                      logs: logs,
                      isConnected: isConnected,
                      connect: connect,
                      disconnect: disconnect,
                      send: send,
                      back: back,
                      save: save)
        .onAppear {
            if (uri != URI.empty) {
                ipAddress = uri.ip
                port = uri.port
            }
        }
    }
}


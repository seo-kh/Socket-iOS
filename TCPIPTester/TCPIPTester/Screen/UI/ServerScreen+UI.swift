//
//  ServerScreen+UI.swift
//  TCPIPTester
//
//  Created by alphacircle on 11/28/25.
//

import SwiftUI

extension ServerScreen {
    struct _ServerScreen: View {
        @Binding
        var port: String
        
        let logs: [Log]
        
        let isConnected: Bool
        
        let connect: () -> Void
        
        let disconnect: () -> Void
        
        let back: () -> Void
        
        private var readyToConnect: Bool {
            !port.isEmpty
        }
        
        var body: some View {
            VStack(alignment: .center, spacing: 0.0) {
                
                VStack(alignment: .leading, spacing: 64.0) {
                    
                    // header
                    ZStack(alignment: .leading) {
                        Text("Server")
                            .font(.system(size: 32, weight: .medium, design: .monospaced))
                            .frame(maxWidth: .infinity)
                        
                        Button("Back", systemImage: "arrowshape.left.fill", role: .close) {
                            back()
                        }
                        .buttonStyle(.plain)
                    }
                    
                    
                    // body
                    Grid(alignment: .center, horizontalSpacing: 8.0, verticalSpacing: 16.0) {
                        
                        GridRow {
                            Text("Port")
                            
                            TextField("Port number", text: $port)
                                .foregroundStyle(.black)
                                .textFieldStyle(.roundedBorder)
                            
                            Button(isConnected ? "Disconnect" : "Connect") {
                                if (isConnected) {
                                    disconnect()
                                } else {
                                    connect()
                                }
                            }
                            .buttonStyle(TCPIPButtonStyle(size: 12, disabled: !readyToConnect))
                            .disabled(!readyToConnect)
                        }
                        
                        GridRow(alignment: .top) {
                            Text("Logs")
                            
                            List(logs) { log in
                                Text(log.message)
                                    .foregroundStyle(log.role == .client ? Color.red : Color.blue)
                            }
                            .listStyle(.automatic)
                            .foregroundStyle(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .gridCellColumns(2)
                        }
                    }
                }
                .padding(.horizontal, 36.0)
                .padding(.vertical, 18.0)
                .foregroundStyle(Color.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.BG)
        }
    }
}

#Preview("1. DISCONNECTED") {
    ServerScreen._ServerScreen(port: .constant(""), logs: [], isConnected: false, connect: {}, disconnect: {}, back: {})
        .frame(minWidth: 600, minHeight: 450)
}

#Preview("2. READY TO CONNECT") {
    ServerScreen._ServerScreen(port: .constant("89"), logs: [], isConnected: false, connect: {}, disconnect: {}, back: {})
        .frame(minWidth: 600, minHeight: 450)
}

#Preview("3. ALREADY CONNECTED") {
    ServerScreen._ServerScreen(port: .constant("89"), logs: [], isConnected: true, connect: {}, disconnect: {}, back: {})
        .frame(minWidth: 600, minHeight: 450)
}

#Preview("4. Listen MESSAGE") {
    ServerScreen._ServerScreen(port: .constant("89"),
                               logs: [
                                Log(id: 0, role: .client, message: "Request from client"),
                               ],
                               isConnected: true,
                               connect: {},
                               disconnect: {}, back: {})
    .frame(minWidth: 600, minHeight: 450)
}


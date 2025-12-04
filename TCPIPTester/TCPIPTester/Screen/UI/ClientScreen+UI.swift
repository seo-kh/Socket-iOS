//
//  ClientScreen+UI.swift
//  TCPIPTester
//
//  Created by alphacircle on 11/28/25.
//

import SwiftUI

extension ClientScreen {
    struct _ClientScreen: View {
        @Binding
        var ipAddress: String
        
        @Binding
        var port: String
        
        @Binding
        var message: String
        
        let logs: [Log]
        
        let isConnected: Bool
        
        let connect: () -> Void
        
        let disconnect: () -> Void
        
        let send: () -> Void
        
        let back: () -> Void
        
        let save: () -> Void
        
        private var readyToConnect: Bool {
            !ipAddress.isEmpty && !port.isEmpty
        }
        
        private var isSendable: Bool {
            !message.isEmpty
        }
        
        var body: some View {
            VStack(alignment: .center, spacing: 0.0) {
                
                VStack(alignment: .leading, spacing: 64.0) {
                    
                    // header
                    ZStack(alignment: .leading) {
                        Text("Client")
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
                            Text("Address")
                                .gridColumnAlignment(.trailing)
                            
                            TextField("IP address", text: $ipAddress)
                                .foregroundStyle(.black)
                                .textFieldStyle(.roundedBorder)
                            
                            Button("IP/Port Save") {
                                save()
                            }
                            .buttonStyle(TCPIPButtonStyle(size: 12, disabled: false))
                        }
                        
                        GridRow {
                            Text("Port")
                            
                            TextField("Port number", text: $port)
                                .foregroundStyle(.black)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit {
                                    if (isConnected) {
                                        disconnect()
                                    } else {
                                        connect()
                                    }
                                }
                            
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
                        
                        GridRow {
                            Text("Message")
                            
                            TextField("type your message here..", text: $message)
                                .foregroundStyle(.black)
                                .textFieldStyle(.roundedBorder)
                                .onSubmit {
                                    if (isConnected && isSendable) {
                                        send()
                                    }
                                }
                            
                            Button("send") {
                                send()
                            }
                            .buttonStyle(TCPIPButtonStyle(size: 12, disabled: !isConnected || !isSendable))
                            .disabled(!isConnected && !isSendable)
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
    ClientScreen._ClientScreen(ipAddress: .constant(""),
                               port: .constant(""),
                               message: .constant(""),
                               logs: [],
                               isConnected: false,
                               connect: {},
                               disconnect: {},
                               send: {},
                               back: {},
                               save: {})
    .frame(minWidth: 600, minHeight: 450)
}

#Preview("2. READY TO CONNECT") {
    ClientScreen._ClientScreen(ipAddress: .constant("128.0.0.8"),
                               port: .constant("50"),
                               message: .constant(""),
                               logs: [],
                               isConnected: false,
                               connect: {},
                               disconnect: {},
                               send: {},
                               back: {},
                               save: {})
    .frame(minWidth: 600, minHeight: 450)
}

#Preview("3. ALREADY CONNECTED") {
    ClientScreen._ClientScreen(ipAddress: .constant("128.0.0.8"),
                               port: .constant("50"),
                               message: .constant(""),
                               logs: [],
                               isConnected: true,
                               connect: {},
                               disconnect: {},
                               send: {},
                               back: {},
                               save: {})
    .frame(minWidth: 600, minHeight: 450)
}

#Preview("4. WRITE MESSAGE") {
    ClientScreen._ClientScreen(ipAddress: .constant("128.0.0.8"),
                               port: .constant("50"),
                               message: .constant("Hello, Server!"),
                               logs: [],
                               isConnected: true,
                               connect: {},
                               disconnect: {},
                               send: {},
                               back: {},
                               save: {})
    .frame(minWidth: 600, minHeight: 450)
}

#Preview("5. SENT MESSAGE") {
    ClientScreen._ClientScreen(ipAddress: .constant("128.0.0.8"),
                               port: .constant("50"),
                               message: .constant(""),
                               logs: [
                                Log(id: 0, role: .client, message: "Hello, Server!"),
                                Log(id: 1, role: .server, message: "Hello, Client!"),
                               ],
                               isConnected: true,
                               connect: {},
                               disconnect: {},
                               send: {},
                               back: {},
                               save: {})
    .frame(minWidth: 600, minHeight: 450)
}

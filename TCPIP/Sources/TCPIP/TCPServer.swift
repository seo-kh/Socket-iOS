//
//  TCPServer.swift
//  TCPIP
//
//  Created by alphacircle on 11/26/25.
//

import Foundation
import Network

public final actor TCPServer {
    private var listener: NWListener
    private var connections: [NWConnection] = []
    
    public init(port: UInt16, using parameters: NWParameters) throws {
        self.listener = try NWListener(using: parameters,
                                       on: NWEndpoint.Port(rawValue: port)!)
    }
        
    public func connect() {
        self.listener.start(queue: .main)
        self.listener.newConnectionHandler = self.setupConnection(_:)
    }
    
    public func disconnect() {
        listener.cancel()
        listener.newConnectionHandler = nil
        connections.forEach(cleanupConnection(_:))
        connections.removeAll(keepingCapacity: true)
    }
    
    public func stateNotifier() -> AsyncStream<NWListener.State> {
        AsyncStream { cont in
            listener.stateUpdateHandler = { newState in
                cont.yield(newState)
                
            }
        }
    }
}

extension TCPServer {
    
    private func connectionStateNotifier(_ state: NWConnection.State) {
        switch state {
        case .setup:
            print("connection setup")
        case .waiting(let nWError):
            print("connection waiting: \(nWError)")
        case .preparing:
            print("connection preparing")
        case .ready:
            print("connection ready")
        case .failed(let nWError):
            print("connection failed: \(nWError)")
        case .cancelled:
            print("connection cancelled")
        default:
            fatalError()
        }
    }
    
    private func setupConnection(_ newConnection: NWConnection) {
        newConnection.stateUpdateHandler = self.connectionStateNotifier(_:)
        // self.receiveData(on: newConnection)
        newConnection.start(queue: DispatchQueue(label: "server"))
        self.connections.append(newConnection)
        Task {
            do {
                try await Task.sleep(for: .seconds(1))
                try await receiveData(for: newConnection)
            } catch {
                print("setup connection failed: \(error)")
            }
        }
    }
    
    private func receiveData(on connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65535) { data, context, isComplete, error in
            if let data = data, !data.isEmpty {
                let message = String(data: data, encoding: .utf8) ?? "비-UTF8 데이터"
                print("서버 수신: \(message)")
                
                connection.send(content: data, completion: .contentProcessed({ error in
                    if let error = error {
                        print("에코 송신 실패: \(error)")
                    } else {
                        print("서버 에코 완료")
                    }
                }))
            }
            
            if let error = error {
                print("서버 수신 오류: \(error)")
                connection.cancel()
                return
            }
        }
    }
    
    private func receiveData(for connection: NWConnection) async throws {
        while(connection.state == .ready) {
            if let msgData = try await income(on: connection),
               let msg = String(data: msgData, encoding: .utf8) {
                
                print("서버 수신: \(msg)")
                try await outcome(data: msgData, on: connection)
                print("서버 에코 완료: \(msg)")
            }
            print("epoch")
        }
    }
    
    private func outcome(data: Data, on connection: NWConnection) async throws {
        return try await withCheckedThrowingContinuation { cont in
            connection.send(content: data, completion: .contentProcessed({ error in
                if let error {
                    cont.resume(throwing: error)
                } else {
                    cont.resume()
                }
            }))
        }
    }
    
    private func income(on connection: NWConnection) async throws -> Data? {
        return try await withCheckedThrowingContinuation { con in
            connection.receive(minimumIncompleteLength: 1, maximumLength: 65535) { content, contentContext, isComplete, error in
                if let error {
                    con.resume(throwing: error)
                    return
                }
                
                con.resume(returning: content)
            }
        }
    }

    private func cleanupConnection(_ connection: NWConnection) {
        connection.cancel()
        connection.stateUpdateHandler = nil
    }
}

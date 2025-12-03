//
//  TCPClient.swift
//  TCPIP
//
//  Created by alphacircle on 11/26/25.
//

import Network
import Foundation

public final class TCPClient {
    private var connection: NWConnection
    
    public init?(host: String, port: UInt16, using parameters: NWParameters) {
        let host = NWEndpoint.Host(host)
        guard let port = NWEndpoint.Port(rawValue: port) else { return nil }
        self.connection = NWConnection(host: host, port: port, using: parameters)
    }
    
    deinit {
        disconnect()
    }
    
    public func stateNotifier() -> AsyncStream<NWConnection.State> {
        AsyncStream { cont in
            connection.stateUpdateHandler = { newState in
                cont.yield(newState)
            }
        }
    }
    
    public func connect(queue: DispatchQueue) {
        connection.start(queue: queue)
    }
    
    public func receive() async throws -> (Data?, NWConnection.ContentContext?, Bool) {
        try await withCheckedThrowingContinuation({ cont in
            connection.receive(minimumIncompleteLength: 1, maximumLength: 65535) { content, contentContext, isComplete, error in
                if let error = error {
                    cont.resume(throwing: error)
                } else {
                    cont.resume(returning: (content, contentContext, isComplete))
                }
            }
        })
    }
    
    public func disconnect() {
        connection.cancel()
        connection.stateUpdateHandler = nil
    }
    
    public func send(data: Data) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            connection.send(content: data, completion: .contentProcessed({ error in
                if let error = error {
                    cont.resume(throwing: error)
                } else {
                    cont.resume()
                }
            }))
        }
    }
}


//public final class TCPClient: Sendable {
//    private let connection: NWConnection
//    
//    public convenience init(host: String, port: UInt16) {
//        // 1. 통신 엔드포인트와 사용할 프로토콜 설정 (TCP)
//        let host = NWEndpoint.Host(host)
//        let port = NWEndpoint.Port(rawValue: port)!
//        
//        self.init(NWConnection(host: host, port: port, using: .tcp))
//    }
//    
//    public init(_ connection: NWConnection) {
//        self.connection = connection
//    }
//    
//    public func connect() {
//        // 1. 연결 상태 변화를 처리할 큐 정의
//        let queue = DispatchQueue(label: "com.alphacircle.clientQueue")
//        
//        // 2. 상태 핸들러 설정
//        connection.stateUpdateHandler = { [weak self] newState in
//            switch newState {
//            case .ready:
//                print("연결 성공 (Ready)")
//            case .failed(let error):
//                print("연결 실패: \(error)")
//            case .cancelled:
//                print("연결 취소")
//            case .preparing:
//                print("연결 중..")
//            case .setup:
//                print("연결 준비됨")
//            case .waiting(let error):
//                print("새로운 연결 대기중: \(error)")
//            @unknown default:
//                fatalError()
//            }
//        }
//        
//        // 3. 연결 시작
//        connection.start(queue: queue)
//    }
//
//    
//    private func receive() {
//        connection.receive(minimumIncompleteLength: 1, maximumLength: 65535) { [weak self] data, context, isComplete, error in
//            if let data = data, !data.isEmpty {
//                let message = String(data: data, encoding: .utf8) ?? "비-UTF8 데이터"
//                print("데이터 수신: \(message)")
//            }
//            
//            if let error = error {
//                print("데이터 수신 오류: \(error)")
//                self?.connection.cancel()
//                return
//            }
//            
//            self?.receive()
//        }
//    }
//    
//    public func disconnect() {
//        connection.cancel()
//    }
//    
//    public func send(data: Data) {
//        connection.send(content: data, completion: .contentProcessed({ error in
//            if let error = error {
//                print("데이터 송신 실패: \(error)")
//            } else {
//                print("데이터 송신 완료: \(data.count) bytes")
//            }
//        }))
//    }
//}

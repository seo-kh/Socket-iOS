//
//  URI.swift
//  TCPIPTester
//
//  Created by alphacircle on 12/4/25.
//

import Foundation

struct URI: RawRepresentable {
    var rawValue: String {
        "\(ip):\(port)"
    }
    
    init?(rawValue: String) {
        let sources = rawValue.components(separatedBy: ":")
        guard sources.count == 2 else { return nil }
        self.init(ip: sources[0], port: sources[1])
    }
    
    init(ip: String, port: String) {
        self.ip = ip
        self.port = port
    }
    
    var ip: String
    var port: String
    
    static let key: String = "URI"
    
    static let empty: URI = URI(ip: "", port: "")
}

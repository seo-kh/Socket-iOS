//
//  Role.swift
//  TCPIPTester
//
//  Created by alphacircle on 11/27/25.
//

import Foundation

enum Role: CaseIterable, Identifiable, Descriptable {
    case server
    case client
    
    var id: Self { self }
    
    static let name: String = "Role"

    var title: String {
        switch self {
        case .server:
            "Server"
        case .client:
            "Client"
        }
    }
}

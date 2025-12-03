//
//  Log.swift
//  TCPIPTester
//
//  Created by alphacircle on 11/27/25.
//

import Foundation

struct Log: Identifiable {
    let id: Int
    let role: Role
    let message: String
    
    init(id: Int, role: Role, message: String) {
        self.id = id
        self.role = role
        self.message = role.title + ": " + message
    }
}

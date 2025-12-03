//
//  ProtocolType.swift
//  TCPIPTester
//
//  Created by alphacircle on 11/27/25.
//

import Foundation
import Network

enum ProtocolType: CaseIterable, Identifiable, Descriptable {
    case tcp
    //case udp
    
    var id: Self { self }
    
    static let name: String = "Protocol"
    
    var parameter: NWParameters {
        switch self {
        case .tcp:
            NWParameters.tcp
//        case .udp:
//            NWParameters.udp
        }
    }
    
    var title: String {
        switch self {
        case .tcp:
            "TCP"
//        case .udp:
//            "UDP"
        }
    }
}

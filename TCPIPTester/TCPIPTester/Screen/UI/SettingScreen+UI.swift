//
//  SettingScreen+UI.swift
//  TCPIPTester
//
//  Created by alphacircle on 11/28/25.
//

import SwiftUI

extension SettingScreen {
    struct _SettingScreen: View {
        @Binding
        var protocolType: ProtocolType
        
        @Binding
        var role: Role
        
        let startAction: () -> Void
        
        var body: some View {
            VStack(alignment: .center, spacing: 0.0) {
                VStack(alignment: .center, spacing: 92.0) {
                    Text("Network")
                        .font(.system(size: 64, weight: .medium, design: .monospaced))
                    
                    Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 36.0, verticalSpacing: 18.0) {
                        GridRow(alignment: .center) {
                            Text(ProtocolType.name)
                                .font(.system(size: 32, weight: .regular, design: .monospaced))
                                .gridColumnAlignment(.trailing)
                            
                            SettingPicker(selection: $protocolType)
                        }
                        
                        GridRow(alignment: .center) {
                            Text(Role.name)
                                .font(.system(size: 32, weight: .regular, design: .monospaced))
                            
                            SettingPicker(selection: $role)
                        }
                    }
                    
                    Button("Start") {
                        startAction()
                    }
                    .buttonStyle(TCPIPButtonStyle(size: 32.0))
                }
                .fixedSize()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(.white)
            .background(Color.BG)
        }
    }
    
    private struct SettingPicker<T>: View where T: CaseIterable, T: Identifiable, T: Descriptable, T: Hashable, T.AllCases: RandomAccessCollection {
        @Binding var selection: T
        
        var body: some View {
            Picker(T.name, selection: $selection) {
                ForEach(T.allCases, id: \.id) { eachCase in
                    Text(eachCase.title)
                        .foregroundStyle(.white)
                        .font(.system(size: 24, weight: .regular, design: .monospaced))
                        .tag(eachCase)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
        }
    }
}


#Preview {
    SettingScreen._SettingScreen(protocolType: .constant(.tcp), role: .constant(.server), startAction: {})
        .frame(minWidth: 600, minHeight: 450)
}

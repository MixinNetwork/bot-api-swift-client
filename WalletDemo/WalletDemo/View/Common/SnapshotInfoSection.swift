//
//  SnapshotInfoSection.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/7/8.
//

import SwiftUI

struct SnapshotInfoSection: View {
    
    let header: String
    let content: String?
    
    var body: some View {
        if let content = content, !content.isEmpty {
            Section {
                Text(content)
                    .font(.callout.monospaced())
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            } header: {
                Text(header)
            }
        } else {
            EmptyView()
        }
    }
    
}

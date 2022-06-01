//
//  AssetIconView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/29.
//

import SwiftUI
import MixinAPI
import SDWebImageSwiftUI

struct AssetIconView: View {
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(Color(UIColor.secondarySystemBackground))
                WebImage(url: icon.asset)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                Circle()
                    .fill(Color(UIColor.secondarySystemBackground))
                    .scaleEffect(chainIconBackgroundScale, anchor: .center)
                    .offset(chainIconOffset(assetIconSize: geometry.size, scale: chainIconBackgroundScale))
                WebImage(url: icon.chain)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .scaleEffect(chainIconScale, anchor: .center)
                    .offset(chainIconOffset(assetIconSize: geometry.size, scale: chainIconBackgroundScale))
            }
        }
    }
    
    private let icon: AssetIcon
    private let chainIconBackgroundScale: CGFloat = 0.47
    private let chainIconScale: CGFloat = 0.4
    
    init(icon: AssetIcon) {
        self.icon = icon
    }
    
    private func chainIconOffset(assetIconSize: CGSize, scale: CGFloat) -> CGSize {
        let length = min(assetIconSize.width, assetIconSize.height)
        let factor = (1 - scale) / 2
        return CGSize(width: -length * factor, height: length * factor)
    }
    
}

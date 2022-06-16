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
                WebImage(url: assetIconURL)
                    .resizable()
                    .scaledToFit()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Circle())
                Circle()
                    .fill(Color(.secondarySystemBackground))
                    .scaleEffect(chainIconBackgroundScale, anchor: .bottomLeading)
                    .offset(x: -(chainIconBackgroundScale - chainIconScale) * geometry.size.width / 2,
                            y: (chainIconBackgroundScale - chainIconScale) * geometry.size.height / 2)
                WebImage(url: chainIconURL)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .scaleEffect(chainIconScale, anchor: .bottomLeading)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(Rectangle())
    }
    
    private let assetIconURL: URL?
    private let chainIconURL: URL?
    private let chainIconBackgroundScale: CGFloat = 0.47
    private let chainIconScale: CGFloat = 0.4
    
    init(icon: AssetIcon) {
        self.assetIconURL = icon.asset
        self.chainIconURL = icon.chain
    }
    
}

struct AssetIconView_Previews: PreviewProvider {
    
    static var previews: some View {
        AssetIconView(icon: .init(asset: nil, chain: nil))
    }
    
}

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
    
    private let chainIconBackgroundScale: CGFloat = 0.47
    private let chainIconScale: CGFloat = 0.4
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(Color(UIColor.secondarySystemBackground))
                WebImage(url: viewModel.assetIconURL)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                Circle()
                    .fill(Color(UIColor.secondarySystemBackground))
                    .scaleEffect(chainIconBackgroundScale, anchor: .center)
                    .offset(chainIconOffset(assetIconSize: geometry.size, scale: chainIconBackgroundScale))
                WebImage(url: viewModel.chainIconURL)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .scaleEffect(chainIconScale, anchor: .center)
                    .offset(chainIconOffset(assetIconSize: geometry.size, scale: chainIconBackgroundScale))
            }
        }
    }
    
    private let viewModel: AssetViewModel
    
    init(viewModel: AssetViewModel) {
        self.viewModel = viewModel
    }
    
    private func chainIconOffset(assetIconSize: CGSize, scale: CGFloat) -> CGSize {
        let length = min(assetIconSize.width, assetIconSize.height)
        let factor = (1 - scale) / 2
        return CGSize(width: -length * factor, height: length * factor)
    }
    
}

struct AssetIconView_Previews: PreviewProvider {
    
    static let iconURL = URL(string: "https://mixin-images.zeromesh.net/zVDjOxNTQvVsA8h2B4ZVxuHoCF3DJszufYKWpd9duXUSbSapoZadC7_13cnWBqg0EmwmRcKGbJaUpA8wFfpgZA=s128")!
    static let viewModel = AssetViewModel(assetID: "",
                                          assetIconURL: iconURL,
                                          chainIconURL: iconURL,
                                          symbol: "ETH",
                                          balance: "",
                                          change: "",
                                          isChangePositive: false,
                                          usdPrice: "",
                                          usdBalance: "",
                                          decimalBalance: 0,
                                          decimalUSDPrice: 0,
                                          decimalUSDBalance: 0,
                                          decimalBTCBalance: 0)
    
    static var previews: some View {
        AssetIconView(viewModel: viewModel)
    }
    
}

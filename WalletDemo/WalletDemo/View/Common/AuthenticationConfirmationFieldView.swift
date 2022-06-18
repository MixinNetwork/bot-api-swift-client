//
//  AuthenticationConfirmationFieldView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/18.
//

import UIKit

class AuthenticationConfirmationFieldView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var separatorLineHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorLineHeightConstraint.constant = 1 / UIScreen.main.scale
        descriptionLabel.font = .monospacedSystemFont(ofSize: 15, weight: .regular)
    }
    
}

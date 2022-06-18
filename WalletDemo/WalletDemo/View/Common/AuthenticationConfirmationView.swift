//
//  AuthenticationConfirmationView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/18.
//

import UIKit

class AuthenticationConfirmationView: UIView {
    
    @IBOutlet weak var fieldsStackView: UIStackView!
    @IBOutlet weak var confirmButton: UIButton!
    
    func load(fields: [Authentication.Field]) {
        fieldsStackView.arrangedSubviews.forEach(fieldsStackView.removeArrangedSubview(_:))
        let nib = UINib(nibName: "AuthenticationConfirmationFieldView", bundle: .main)
        for field in fields {
            let view = nib.instantiate(withOwner: nil).first as! AuthenticationConfirmationFieldView
            view.titleLabel.text = field.title
            view.descriptionLabel.text = field.description
            fieldsStackView.addArrangedSubview(view)
        }
    }
    
}

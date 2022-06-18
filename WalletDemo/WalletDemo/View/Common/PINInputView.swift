//
//  PINInputView.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/17.
//

import UIKit

class PINInputView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var pinField: PINField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var successImageView: UIImageView!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    
    func updateViews(state: Authentication.State) {
        let isPINFieldFirstResponder: Bool
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        for view in stackView.arrangedSubviews {
            view.isHidden = true
        }
        switch state {
        case .waiting:
            pinField.isHidden = false
            isPINFieldFirstResponder = true
        case .loading:
            activityIndicator.isHidden = false
            isPINFieldFirstResponder = false
        case .success:
            successImageView.isHidden = false
            isPINFieldFirstResponder = false
        case .failure(let error):
            errorDescriptionLabel.text = error.localizedDescription
            errorDescriptionLabel.isHidden = false
            pinField.clear()
            pinField.isHidden = false
            isPINFieldFirstResponder = true
        }
        CATransaction.commit()
        if isPINFieldFirstResponder {
            pinField.becomeFirstResponder()
        } else {
            pinField.resignFirstResponder()
        }
    }
    
}

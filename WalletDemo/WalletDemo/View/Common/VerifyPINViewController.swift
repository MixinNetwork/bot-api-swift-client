//
//  VerifyPINViewController.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/13.
//

import UIKit
import Combine
import SwiftUI

class VerifyPINViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentBackgroundView: UIVisualEffectView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var stateRepresentationStackView: UIStackView!
    @IBOutlet weak var pinField: PINField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var successImageView: UIImageView!
    @IBOutlet weak var errorDescriptionLabel: UILabel!
    
    @IBOutlet weak var hideContentConstraint: NSLayoutConstraint!
    @IBOutlet weak var showContentConstraint: NSLayoutConstraint!
    @IBOutlet weak var stateRepresentationBottomConstraint: NSLayoutConstraint!
    
    private let viewModel: WalletViewModel
    private let stateRepresentationBottomMargin: CGFloat = 20
    
    private var presentationObserver: AnyCancellable?
    private var stateObserver: AnyCancellable?
    private var captionObserver: AnyCancellable?
    
    init(viewModel: WalletViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "VerifyPINView", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        pinField.becomeFirstResponder()
        stateRepresentationBottomConstraint.constant = view.safeAreaInsets.bottom + stateRepresentationBottomMargin
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViews(isPresented: viewModel.isPINVerificationPresented, completion: nil)
        updateViews(state: viewModel.pinVerificationState)
        updateViews(caption: viewModel.pinVerificationCaption)
        presentationObserver = viewModel.$isPINVerificationPresented.sink { isPresented in
            self.updateViews(isPresented: isPresented, completion: nil)
        }
        stateObserver = viewModel.$pinVerificationState.sink { state in
            self.updateViews(state: state)
        }
        captionObserver = viewModel.$pinVerificationCaption.sink { caption in
            self.updateViews(caption: caption)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presentationObserver?.cancel()
        stateObserver?.cancel()
        captionObserver?.cancel()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        stateRepresentationBottomConstraint.constant = view.safeAreaInsets.bottom + stateRepresentationBottomMargin
    }
    
    @IBAction func cancelVerification(_ sender: Any) {
        switch viewModel.pinVerificationState {
        case .waiting, .failure:
            pinField.resignFirstResponder()
            updateViews(isPresented: false, completion: viewModel.dismissPINVerification)
        case .loading, .success:
            break
        }
    }
    
    @IBAction func pinFieldEditingChanged(_ field: PINField) {
        if field.text.count == PINField.pinDigitCount {
            viewModel.onPINInput?(field.text)
        }
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let frame = view.convert(endFrame, from: UIScreen.main.coordinateSpace)
        showContentConstraint.constant = view.frame.height - frame.origin.y
        view.layoutIfNeeded()
    }
    
    private func updateViews(isPresented: Bool, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .init(rawValue: UInt(7 << 16))) {
            self.backgroundView.alpha = isPresented ? 1 : 0
            self.hideContentConstraint.priority = isPresented ? .defaultLow : .defaultHigh
            self.showContentConstraint.priority = isPresented ? .defaultHigh : .defaultLow
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion?()
        }
    }
    
    private func updateViews(state: WalletViewModel.State) {
        let isPINFieldFirstResponder: Bool
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        for view in stateRepresentationStackView.arrangedSubviews {
            view.isHidden = true
        }
        switch state {
        case .waiting:
            cancelButton.isHidden = false
            pinField.isHidden = false
            isPINFieldFirstResponder = true
        case .loading:
            cancelButton.isHidden = true
            activityIndicator.isHidden = false
            isPINFieldFirstResponder = false
        case .success:
            cancelButton.isHidden = true
            successImageView.isHidden = false
            isPINFieldFirstResponder = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.updateViews(isPresented: false, completion: self.viewModel.dismissPINVerification)
            }
        case .failure(let error):
            cancelButton.isHidden = false
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
    
    private func updateViews(caption: String) {
        captionLabel.text = caption
    }
    
}

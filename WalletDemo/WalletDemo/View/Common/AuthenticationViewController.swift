//
//  AuthenticationViewController.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/6/13.
//

import UIKit
import Combine
import SwiftUI

class AuthenticationViewController: UIViewController {
    
    enum InitializePINError: LocalizedError {
        
        case mismatched
        
        var errorDescription: String? {
            switch self {
            case .mismatched:
                return "Mismatched PIN"
            }
        }
        
    }
    
    enum OperationViewPosition {
        case left, right
    }
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentBackgroundView: UIVisualEffectView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var operationView: UIView!
    
    @IBOutlet weak var hideContentConstraint: NSLayoutConstraint!
    @IBOutlet weak var showContentConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    private let authentication: Authentication
    
    private var isPresented: Binding<Bool>
    
    private var operationViewPosition: OperationViewPosition = .left
    private var leftPIN: String?
    
    private var leftOperationView: UIView!
    private var leftPINField: PINField?
    private var leftOperationViewLeadingConstraint: NSLayoutConstraint!
    private var leftOperationViewBottomConstraint: NSLayoutConstraint!
    
    private var rightOperationView: UIView!
    private var rightPINField: PINField?
    private var rightOperationViewTrailingConstraint: NSLayoutConstraint!
    private var rightOperationViewBottomConstraint: NSLayoutConstraint!
    
    init(authentication: Authentication, isPresented: Binding<Bool>) {
        self.authentication = authentication
        self.isPresented = isPresented
        super.init(nibName: "AuthenticationView", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerViewBottomConstraint.constant = view.safeAreaInsets.bottom
        separatorLineHeightConstraint.constant = 1 / UIScreen.main.scale
        captionLabel.text = authentication.title
        
        let leftOperationView: UIView
        let rightOperationView: UIView
        switch authentication.operation {
        case .verify(let fields):
            leftOperationView = {
                let nib = UINib(nibName: "AuthenticationConfirmationView", bundle: .main)
                let view = nib.instantiate(withOwner: nil).first as! AuthenticationConfirmationView
                view.load(fields: fields)
                view.confirmButton.addTarget(self, action: #selector(moveToRightView), for: .touchUpInside)
                return view
            }()
            rightOperationView = {
                let nib = UINib(nibName: "PINInputView", bundle: .main)
                let view = nib.instantiate(withOwner: nil).first as! PINInputView
                view.pinField.addTarget(self, action: #selector(pinFieldEditingChanged(_:)), for: .editingChanged)
                rightPINField = view.pinField
                return view
            }()
        case .initialize:
            cancelButton.isHidden = true
            let nib = UINib(nibName: "PINInputView", bundle: .main)
            leftOperationView = {
                let view = nib.instantiate(withOwner: nil).first as! PINInputView
                view.titleLabel.text = "Initialize your PIN"
                view.subtitleLabel.text = "Initialize a PIN to access your wallet fully-functional"
                view.pinField.addTarget(self, action: #selector(pinFieldEditingChanged(_:)), for: .editingChanged)
                leftPINField = view.pinField
                return view
            }()
            rightOperationView = {
                let view = nib.instantiate(withOwner: nil).first as! PINInputView
                view.titleLabel.text = "Initialize your PIN"
                view.subtitleLabel.text = "Input that PIN again to confirm it"
                view.pinField.addTarget(self, action: #selector(pinFieldEditingChanged(_:)), for: .editingChanged)
                rightPINField = view.pinField
                return view
            }()
        }
        
        for view in operationView.subviews {
            view.removeFromSuperview()
        }
        operationView.addSubview(leftOperationView)
        operationView.addSubview(rightOperationView)
        
        let leftLeadingConstraint = leftOperationView.leadingAnchor.constraint(equalTo: operationView.leadingAnchor)
        leftLeadingConstraint.priority = .defaultHigh
        self.leftOperationViewLeadingConstraint = leftLeadingConstraint
        
        let leftBottomConstraint = leftOperationView.bottomAnchor.constraint(equalTo: operationView.bottomAnchor)
        self.leftOperationViewBottomConstraint = leftLeadingConstraint
        
        let rightTrailingConstraint = rightOperationView.trailingAnchor.constraint(equalTo: operationView.trailingAnchor)
        rightTrailingConstraint.priority = .defaultLow
        self.rightOperationViewTrailingConstraint = rightTrailingConstraint
        
        let rightBottomConstraint = rightOperationView.bottomAnchor.constraint(equalTo: operationView.bottomAnchor)
        self.rightOperationViewBottomConstraint = rightBottomConstraint
        
        let constraints = [
            leftLeadingConstraint,
            leftBottomConstraint,
            leftOperationView.topAnchor.constraint(equalTo: operationView.topAnchor),
            leftOperationView.widthAnchor.constraint(equalTo: operationView.widthAnchor),
            
            leftOperationView.trailingAnchor.constraint(equalTo: rightOperationView.leadingAnchor),
            
            rightTrailingConstraint,
            rightOperationView.topAnchor.constraint(equalTo: operationView.topAnchor),
            rightOperationView.widthAnchor.constraint(equalTo: operationView.widthAnchor),
        ]
        leftOperationView.translatesAutoresizingMaskIntoConstraints = false
        rightOperationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
        
        self.leftOperationView = leftOperationView
        self.rightOperationView = rightOperationView
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViews(isPresented: isPresented.wrappedValue, completion: nil)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        containerViewBottomConstraint.constant = view.safeAreaInsets.bottom
    }
    
    @IBAction func goBack(_ sender: Any) {
        if operationViewPosition == .right {
            moveToLeftView()
        } else {
            cancelVerification(sender)
        }
    }
    
    @IBAction func cancelVerification(_ sender: Any) {
        guard case .verify = authentication.operation else {
            return
        }
        updateViews(isPresented: false) {
            self.isPresented.wrappedValue = false
        }
    }
    
    @objc private func pinFieldEditingChanged(_ field: PINField) {
        guard field.text.count == PINField.pinDigitCount else {
            return
        }
        let pin = field.text
        switch field {
        case leftPINField:
            leftPIN = pin
            moveToRightView()
        case rightPINField:
            switch authentication.operation {
            case .verify:
                authentication.onPINInput(pin) { state in
                    self.updateViews(state: state)
                    if let view = self.rightOperationView as? PINInputView {
                        view.updateViews(state: state)
                        self.view.layoutIfNeeded()
                    }
                }
            case .initialize:
                if pin == leftPIN {
                    authentication.onPINInput(pin) { state in
                        self.updateViews(state: state)
                        if let view = self.rightOperationView as? PINInputView {
                            view.updateViews(state: state)
                            self.view.layoutIfNeeded()
                        }
                    }
                } else {
                    if let view = leftOperationView as? PINInputView {
                        view.updateViews(state: .failure(InitializePINError.mismatched))
                        view.pinField.clear()
                    }
                    rightPINField?.clear()
                    moveToLeftView()
                }
            }
        default:
            break
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
    
    @objc private func moveToLeftView() {
        guard operationViewPosition == .right else {
            return
        }
        operationViewPosition = .left
        UIView.animate(withDuration: 0.5, delay: 0, options: .init(rawValue: UInt(7 << 16))) {
            self.leftOperationViewLeadingConstraint.priority = .defaultHigh
            self.leftOperationViewBottomConstraint.isActive = true
            self.rightOperationViewTrailingConstraint.priority = .defaultLow
            self.rightOperationViewBottomConstraint.isActive = false
            self.view.layoutIfNeeded()
        }
        if let view = leftOperationView as? PINInputView {
            view.pinField.becomeFirstResponder()
        }
        if let view = rightOperationView as? PINInputView {
            view.pinField.resignFirstResponder()
        }
    }
    
    @objc private func moveToRightView() {
        guard operationViewPosition == .left else {
            return
        }
        operationViewPosition = .right
        UIView.animate(withDuration: 0.5, delay: 0, options: .init(rawValue: UInt(7 << 16))) {
            self.leftOperationViewLeadingConstraint.priority = .defaultLow
            self.leftOperationViewBottomConstraint.isActive = false
            self.rightOperationViewTrailingConstraint.priority = .defaultHigh
            self.rightOperationViewBottomConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
        if let view = rightOperationView as? PINInputView {
            view.pinField.becomeFirstResponder()
        }
    }
    
    private func updateViews(isPresented: Bool, completion: (() -> Void)?) {
        if isPresented {
            if let field = leftPINField {
                field.becomeFirstResponder()
            }
        } else {
            leftPINField?.resignFirstResponder()
            rightPINField?.resignFirstResponder()
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .init(rawValue: UInt(7 << 16))) {
            self.backgroundView.alpha = isPresented ? 1 : 0
            self.hideContentConstraint.priority = isPresented ? .defaultLow : .defaultHigh
            self.showContentConstraint.priority = isPresented ? .defaultHigh : .defaultLow
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion?()
        }
    }
    
    private func updateViews(state: Authentication.State) {
        switch authentication.operation {
        case .verify:
            switch state {
            case .waiting:
                cancelButton.isHidden = false
            case .loading:
                cancelButton.isHidden = true
            case .success:
                cancelButton.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.updateViews(isPresented: false) {
                        self.isPresented.wrappedValue = false
                    }
                }
            case .failure:
                cancelButton.isHidden = false
            }
        case .initialize:
            cancelButton.isHidden = true
            if case .success = state {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.updateViews(isPresented: false) {
                        self.isPresented.wrappedValue = false
                    }
                }
            }
        }
    }
    
}

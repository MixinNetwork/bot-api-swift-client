//
//  PINField.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/28.
//

import UIKit

class PINField: UIControl, UITextInputTraits, UIKeyInput {
    
    static let pinDigitCount = 6
    
    var autocapitalizationType: UITextAutocapitalizationType = .none
    var autocorrectionType: UITextAutocorrectionType = .no
    var spellCheckingType: UITextSpellCheckingType = .no
    var keyboardAppearance: UIKeyboardAppearance = .default
    var keyboardType: UIKeyboardType = .asciiCapableNumberPad
    var returnKeyType: UIReturnKeyType = .default
    var enablesReturnKeyAutomatically: Bool = true
    
    var numberOfDigits: Int = pinDigitCount {
        didSet {
            setupSubviews()
            setNeedsLayout()
        }
    }
    
    var cellLength: CGFloat = 30 {
        didSet {
            setupSubviews()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var text: String {
        digits.joined()
    }
    
    var hasText: Bool {
        !digits.isEmpty
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: cellLength)
    }
    
    override var tintColor: UIColor! {
        didSet {
            for layer in [filledLayers, emptyLayers].flatMap({ $0 }) {
                layer.fillColor = tintColor.cgColor
            }
        }
    }
    
    private let underscoreHeight: CGFloat = 5
    private let underscoreRadius: CGFloat = 2
    private let dotRadius: CGFloat = 10
    
    private var tapRecognizer: UITapGestureRecognizer!
    private var filledLayers = [CAShapeLayer]()
    private var emptyLayers = [CAShapeLayer]()
    
    private var digits: [String] = [] {
        didSet {
            updateCursor()
            sendActions(for: .editingChanged)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let spacing = (bounds.width - CGFloat(numberOfDigits) * cellLength) / CGFloat(numberOfDigits - 1)
        let y = (bounds.height - cellLength) / 2
        for i in 0..<numberOfDigits {
            let x = (cellLength + spacing) * CGFloat(i)
            let frame = CGRect(x: x, y: y, width: cellLength, height: cellLength)
            filledLayers[i].frame = frame
            emptyLayers[i].frame = frame
        }
    }
    
    func clear() {
        digits = []
    }
    
    func insertText(_ text: String) {
        let numberOfUnfilleds = numberOfDigits - digits.count
        let newDigits = text.filter { character in
            character.unicodeScalars.allSatisfy(CharacterSet.decimalDigits.contains(_:))
        }
        let endIndexOfNewDigits = min(numberOfUnfilleds, newDigits.count)
        let digitsToAppend = Array(newDigits)[0..<endIndexOfNewDigits].map{ String($0) }
        if digitsToAppend.count > 0 {
            digits += digitsToAppend
        }
    }
    
    func deleteBackward() {
        _ = digits.popLast()
    }
    
    @objc private func tap(recognizer: UITapGestureRecognizer) {
        becomeFirstResponder()
    }
    
    private func updateCursor() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let position = min(digits.count, numberOfDigits)
        for i in 0..<position {
            filledLayers[i].opacity = 1
            emptyLayers[i].opacity = 0
        }
        for i in position..<numberOfDigits {
            filledLayers[i].opacity = 0
            emptyLayers[i].opacity = 1
        }
        CATransaction.commit()
    }
    
    private func prepare() {
        setupSubviews()
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(recognizer:)))
        addGestureRecognizer(tapRecognizer)
    }
    
    private func setupSubviews() {
        filledLayers.forEach {
            $0.removeFromSuperlayer()
        }
        emptyLayers.forEach {
            $0.removeFromSuperlayer()
        }
        var filled = [CAShapeLayer]()
        var empty = [CAShapeLayer]()
        for _ in 0..<numberOfDigits {
            let underscore = CAShapeLayer()
            let underscoreRect = CGRect(x: 0, y: cellLength - underscoreHeight, width: cellLength, height: underscoreHeight)
            underscore.path = CGPath(roundedRect: underscoreRect, cornerWidth: underscoreRadius, cornerHeight: underscoreRadius, transform: nil)
            underscore.fillColor = tintColor.cgColor
            empty.append(underscore)
            
            let dot = CAShapeLayer()
            let dotRect = CGRect(x: cellLength / 2 - dotRadius, y: cellLength / 2 - dotRadius, width: dotRadius, height: dotRadius)
            dot.path = CGPath(roundedRect: dotRect, cornerWidth: dotRadius, cornerHeight: dotRadius, transform: nil)
            dot.fillColor = tintColor.cgColor
            filled.append(dot)
        }
        filled.forEach(layer.addSublayer(_:))
        empty.forEach(layer.addSublayer(_:))
        filledLayers = filled
        emptyLayers = empty
        updateCursor()
    }
    
}

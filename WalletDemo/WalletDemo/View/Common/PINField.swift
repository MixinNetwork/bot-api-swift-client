//
//  PINField.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/28.
//

import SwiftUI

struct PINField: UIViewRepresentable {
    
    @Binding var text: String
    
    func makeUIView(context: Self.Context) -> Internal {
        let field = Internal()
        field.tintColor = .gray
        field.addTarget(context.coordinator,
                        action: #selector(Coordinator.pinFieldEditingChanged(_:)),
                        for: .editingChanged)
        return field
    }
    
    func updateUIView(_ uiView: Internal, context: Self.Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
    
}

extension PINField {
    
    class Coordinator {
        
        var text: Binding<String>
        
        init(_ text: Binding<String>) {
            self.text = text
        }
        
        @objc fileprivate func pinFieldEditingChanged(_ field: Internal) {
            self.text.wrappedValue = field.text
        }
        
    }
    
    class Internal: UIControl, UITextInputTraits, UIKeyInput {
        
        var filledLayers = [CALayer]()
        var emptyLayers = [CALayer]()
        
        var autocapitalizationType: UITextAutocapitalizationType = .none
        var autocorrectionType: UITextAutocorrectionType = .no
        var spellCheckingType: UITextSpellCheckingType = .no
        var keyboardAppearance: UIKeyboardAppearance = .default
        var returnKeyType: UIReturnKeyType = .default
        var enablesReturnKeyAutomatically: Bool = true
        
        var numberOfDigits: Int = 6 {
            didSet {
                setupSubviews()
                setNeedsLayout()
            }
        }
        
        var cellLength: CGFloat = 10 {
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
        
        override var tintColor: UIColor! {
            didSet {
                setupSubviews()
                setNeedsLayout()
            }
        }
        
        override var canBecomeFirstResponder: Bool {
            true
        }
        
        private var digits: [String] = [] {
            didSet {
                updateCursor()
                sendActions(for: .editingChanged)
            }
        }
        
        private var tapRecognizer: UITapGestureRecognizer!
        
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
            let position = min(digits.count, numberOfDigits)
            for i in 0..<position {
                filledLayers[i].opacity = 1
                emptyLayers[i].opacity = 0
            }
            for i in position..<numberOfDigits {
                filledLayers[i].opacity = 0
                emptyLayers[i].opacity = 1
            }
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
            var filled = [CALayer]()
            var empty = [CALayer]()
            for _ in 0..<numberOfDigits {
                let ring = CAShapeLayer()
                let rect = CGRect(x: 0, y: 0, width: cellLength, height: cellLength)
                ring.path = CGPath(ellipseIn: rect, transform: nil)
                ring.strokeColor = tintColor.cgColor
                ring.fillColor = UIColor.clear.cgColor
                ring.lineWidth = 1
                empty.append(ring)
                let dot = CALayer()
                dot.cornerRadius = cellLength / 2
                dot.masksToBounds = true
                dot.backgroundColor = tintColor.cgColor
                filled.append(dot)
            }
            filled.forEach(layer.addSublayer(_:))
            empty.forEach(layer.addSublayer(_:))
            filledLayers = filled
            emptyLayers = empty
            updateCursor()
        }
        
    }

}

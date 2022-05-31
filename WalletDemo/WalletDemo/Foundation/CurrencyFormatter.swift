import Foundation

public enum CurrencyFormatter {
    
    public enum Format {
        case precision
        case pretty
        case fiatMoney
        case fiatMoneyPrice
    }
    
    public enum SignBehavior {
        case always
        case never
        case whenNegative
    }
    
    public enum Symbol {
        case btc
        case usd
        case percentage
        case custom(String)
    }
    
    public static func localizedString(from decimal: Decimal, format: Format, sign: SignBehavior, symbol: Symbol? = nil) -> String {
        let number = NSDecimalNumber(decimal: decimal)
        var str: String
        
        switch format {
        case .precision:
            setSignBehavior(sign, for: precisionFormatter)
            str = precisionFormatter.string(from: number) ?? ""
        case .pretty:
            setSignBehavior(sign, for: prettyFormatter)
            let numberOfFractionalDigits = max(-decimal.exponent, 0)
            let integralPart = number.rounding(accordingToBehavior: roundToInteger).doubleValue
            if integralPart == 0 {
                prettyFormatter.maximumFractionDigits = 8
            } else if numberOfFractionalDigits > 0 {
                let numberOfIntegralDigits = Int(floor(log10(abs(integralPart)))) + 1
                prettyFormatter.maximumFractionDigits = max(0, 8 - numberOfIntegralDigits)
            } else {
                prettyFormatter.maximumFractionDigits = 0
            }
            str = prettyFormatter.string(from: number) ?? ""
        case .fiatMoney:
            setSignBehavior(sign, for: fiatMoneyFormatter)
            str = fiatMoneyFormatter.string(from: number) ?? ""
        case .fiatMoneyPrice:
            if decimal.isLess(than: 1) {
                setSignBehavior(sign, for: precisionFormatter)
                str = precisionFormatter.string(from: number) ?? ""
            } else {
                setSignBehavior(sign, for: fiatMoneyFormatter)
                str = fiatMoneyFormatter.string(from: number) ?? ""
            }
        }
        
        if let symbol = symbol {
            switch symbol {
            case .btc:
                str += " BTC"
            case .usd:
                str = "$" + str
            case .percentage:
                str += "%"
            case .custom(let symbol):
                str += " " + symbol
            }
        }
        
        return str
    }
    
}

extension CurrencyFormatter {
    
    private static let precisionFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        formatter.roundingMode = .down
        formatter.locale = .current
        return formatter
    }()
    
    private static let prettyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .down
        formatter.locale = .current
        return formatter
    }()
    
    private static let fiatMoneyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .down
        formatter.locale = .current
        return formatter
    }()
    
    private static let roundToInteger = NSDecimalNumberHandler(roundingMode: .down,
                                                               scale: 0,
                                                               raiseOnExactness: false,
                                                               raiseOnOverflow: false,
                                                               raiseOnUnderflow: false,
                                                               raiseOnDivideByZero: false)
    
    private static func setSignBehavior(_ sign: SignBehavior, for formatter: NumberFormatter) {
        switch sign {
        case .always:
            formatter.positivePrefix = formatter.plusSign
            formatter.negativePrefix = formatter.minusSign
        case .never:
            formatter.positivePrefix = ""
            formatter.negativePrefix = ""
        case .whenNegative:
            formatter.positivePrefix = ""
            formatter.negativePrefix = formatter.minusSign
        }
    }
    
}

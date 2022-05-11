# bot-api-swift-client
The [Mixin Network](https://mixin.one/) based wallet allows for the rapid construction of decentralized wallets, decentralized on-chain exchanges, and other products.

# Requirements
- iOS 9.0 or later

# Installation

## Cocoapods
Add it in Podfile
```
pod 'MixinAPI', :git => 'https://github.com/MixinNetwork/bot-api-swift-client.git'
```

# Usage
```swift 
let privateKey = try Ed25519PrivateKey(rawRepresentation: rawKey)
let client = Client(userAgent: "YourApp 0.1.0")
let iterator = CurrentTimePINIterator()
let session = API.AuthenticatedSession(userID: uid,
                                       sessionID: sid,
                                       pinToken: pinToken,
                                       privateKey: privateKey,
                                       client: client,
                                       hostStorage: WalletHost(),
                                       pinIterator: iterator,
                                       analytic: nil)
let api = API(session: session)
```
[More usage](https://github.com/MixinNetwork/bot-api-swift-client/blob/main/WalletDemo/WalletDemo/Model/Example.swift)

## About PIN 
A 6-digit PIN is required when a user is trying to transfer assets, the code functions pretty much like a private key, not retrievable if lost.

- PIN is encrypted with an iterator, which must be incremental and greater than 0. You can pick `CurrentTimePINIterator` to use the current system time as iterator's value, or implement one by yourself with custom value provided. Custom PIN iterator should conforms to protocol `PINIterator`, and provide an incremented value each time when `value()` is called.
- There is a time lock for PIN errors. If you have failed 5 times a day, do not try again, even the PIN is correct after 5 times, an error will be returned. Repeating more times will cause a longer lock time. It is recommended that users write down the tried PIN and try again the next day.
- Once a PIN is lost, it can never be retrieved. It is recommended that the developer let each user enter it regularly to help memorize it. During the initial setting, make sure to let the user enter it more than 3 times and remind the user that it cannot be retrieved if lost
- For asset security, it is recommended to remind users not to set PINs that are too simple or common combinations, such as 123456, 111222.

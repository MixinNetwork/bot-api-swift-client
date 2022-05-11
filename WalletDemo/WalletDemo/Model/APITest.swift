//
//  APITest.swift
//  WalletDemo
//
//  Created by wuyuehyang on 2022/5/9.
//

import Foundation
import Combine
import MixinAPI

class APITest: ObservableObject {
    
    class Case: ObservableObject, Identifiable {
        
        enum State {
            case waiting
            case running
            case succeed
            case failed
        }
        
        typealias OnFinished = (_ hasSucceeded: Bool, _ rawResult: String) -> ()
        typealias Work = (@escaping OnFinished) -> ()
        
        let name: String
        
        @Published private(set) var state: State = .waiting
        
        private let work: Work
        
        init(name: String, work: @escaping Work) {
            self.name = name
            self.work = work
        }
        
        func run() {
            state = .running
            work { (hasSucceeded, _) in
                self.state = hasSucceeded ? .succeed : .failed
            }
        }
        
        func runWithCompletion(_ completion: @escaping (String) -> Void) {
            state = .running
            work { (hasSucceeded, result) in
                completion(result)
                self.state = .waiting
            }
        }
        
    }
    
    class CaseGroup: Identifiable {
        
        let caption: String
        let cases: [Case]
        
        init(caption: String, cases: [Case]) {
            self.caption = caption
            self.cases = cases
        }
        
    }
    
    enum Expectation {
        case success
        case failure(Error)
    }
    
    @Published private(set) var isRunning = false
    @Published private(set) var caseGroups: [CaseGroup] = []
    
    private var pin = ""
    private var receivers: [AnyCancellable] = []
    
    init(session: API.AuthenticatedSession) {
        let api = API(session: session)
        let uuid = "00000000-0000-0000-0000-000000000000"
        let accountGroup = CaseGroup(caption: "Account", cases: [
            Case(name: "Me", work: { (onFinished) in
                api.account.me { result in
                    self.validate(result: result, expect: .success, onFinished: onFinished)
                }
            }),
            Case(name: "Update Profile", work: { onFinished in
                api.account.update(fullName: "Test", biography: "Test Biography", avatarBase64: nil) { result in
                    self.validate(result: result, expect: .success, onFinished: onFinished)
                }
            })
        ])
        let userGroup = CaseGroup(caption: "User", cases: [
            Case(name: "Show", work: { (onFinished) in
                api.user.showUser(userID: "773e5e77-4107-45c2-b648-8fc722ed77f5") { result in
                    self.validate(result: result, expect: .success, onFinished: onFinished)
                }
            }),
        ])
        self.caseGroups = [accountGroup, userGroup]
        self.receivers = caseGroups.enumerated().flatMap { (groupIndex, group) in
            group.cases.enumerated().map { (caseIndex, testCase) in
                testCase.$state.sink { newState in
                    switch newState {
                    case .succeed, .failed:
                        if caseIndex + 1 < group.cases.count {
                            group.cases[caseIndex + 1].run()
                        } else if groupIndex + 1 < self.caseGroups.count, let nextCase = self.caseGroups[groupIndex + 1].cases.first {
                            nextCase.run()
                        } else {
                            self.isRunning = false
                        }
                    default:
                        break
                    }
                    self.objectWillChange.send()
                }
            }
        }
    }
    
    func start(pin: String) {
        assert(!isRunning)
        isRunning = true
        self.pin = pin
        caseGroups.first?.cases.first?.run()
    }
    
    private func validate<Result>(result: API.Result<Result>, expect expectation: Expectation, onFinished: Case.OnFinished) {
        switch (result, expectation) {
        case (.success, .success):
            onFinished(true, "\(result)")
        case let (.failure(resultError), .failure(expectedError)):
            let resultNSError = resultError as NSError
            let expectedNSError = expectedError as NSError
            let isEqual = resultNSError.domain == expectedNSError.domain
                && resultNSError.code == expectedNSError.code
            onFinished(isEqual, "\(result)")
        default:
            onFinished(false, "\(result)")
        }
        self.objectWillChange.send()
    }
    
}

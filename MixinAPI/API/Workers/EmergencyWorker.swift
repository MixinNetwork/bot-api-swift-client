//
//  EmergencyWorker.swift
//  MixinAPI
//
//  Created by wuyuehyang on 2022/5/7.
//

import Foundation

public final class EmergencyWorker: Worker {
    
    private enum Path {
        
        static let create = "/emergency_verifications"
        
        static func verify(id: String) -> String {
            "/emergency_verifications/" + id
        }
        
    }
    
    public func createContact(identityNumber: String, completion: @escaping (API.Result<EmergencyResponse>) -> Void) {
        let parameters = EmergencyRequest(phone: nil,
                                          identityNumber: identityNumber,
                                          pin: nil,
                                          code: nil,
                                          purpose: .contact)
        post(path: Path.create,
             parameters: parameters,
             completion: completion)
    }
    
    public func createSession(phoneNumber: String, identityNumber: String, completion: @escaping (API.Result<EmergencyResponse>) -> Void) {
        let parameters = EmergencyRequest(phone: phoneNumber,
                                          identityNumber: identityNumber,
                                          pin: nil,
                                          code: nil,
                                          purpose: .session)
        post(path: Path.create,
             parameters: parameters,
             options: .authIndependent,
             completion: completion)
    }
    
    public func verifyContact(pin: String, id: String, code: String, completion: @escaping (API.Result<Account>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { pin in
            let parameters = EmergencyRequest(phone: nil,
                                              identityNumber: nil,
                                              pin: pin,
                                              code: code,
                                              purpose: .contact)
            self.post(path: Path.verify(id: id),
                      parameters: parameters,
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
    public func verifySession(id: String, code: String, sessionSecret: String, registrationId: Int, completion: @escaping (API.Result<Account>) -> Void) {
        let parameters = AccountRequest.session(code: code,
                                                registrationId: registrationId,
                                                sessionSecret: sessionSecret,
                                                client: session.client)
        post(path: Path.verify(id: id),
             parameters: parameters,
             options: .authIndependent,
             completion: completion)
    }
    
    public func show(pin: String, completion: @escaping (API.Result<User>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { pin in
            self.post(path: "/emergency_contact",
                      parameters: ["pin_base64": pin],
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
    public func delete(pin: String, completion: @escaping (API.Result<Account>) -> Void) {
        session.encryptPIN(pin, onFailure: completion) { pin in
            self.post(path: "/emergency_contact/delete",
                      parameters: ["pin_base64": pin],
                      options: .disableRetryOnRequestSigningTimeout,
                      completion: completion)
        }
    }
    
}

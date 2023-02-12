//
//  NetworkErrorHandler.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import Foundation

/// Network errors handler

protocol NetworkErrorHandling {
    func handleDecodingError<T: Decodable>(_ error: DecodingError, for: T.Type)
}

struct NetworkErrorHandler: NetworkErrorHandling {
    
    /// DecodingError handling and with displaying details
    func handleDecodingError<T: Decodable>(_ error: DecodingError, for: T.Type) {
        NSLog("NetworkErrorHandler: \(T.self) decoding error")
        switch error {
        case .typeMismatch(let key, let value):
            NSLog("\(error.localizedDescription) \(key), value \(value)")
        case .valueNotFound(let key, let value):
            NSLog("\(error.localizedDescription) \(key), value \(value)")
        case .keyNotFound(let key, let value):
            NSLog("\(error.localizedDescription) \(key), value \(value)")
        case .dataCorrupted(let key):
            NSLog("\(error.localizedDescription) \(key)")
        default:
            NSLog("\(error.localizedDescription)")
        }
    }
}

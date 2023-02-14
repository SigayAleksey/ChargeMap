//
//  FeatureState.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import Foundation

/// Displays the status of receiving a data from the network

enum FeatureState<T: Equatable> {
    case none
    case loading
    case success(result: T)
    case error(error: NetworkError)
}

extension FeatureState: Equatable {
    static func == (lhs: FeatureState<T>, rhs: FeatureState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.loading, .loading):
            return true
        case (.success(let lhsResult), .success(let rhsResult)):
            return lhsResult == rhsResult
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    
    }
}

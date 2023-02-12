//
//  FeatureState.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import Foundation

/// Displays the status of receiving a data from the network

enum FeatureState<T> {
    case none
    case loading
    case success(result: T)
    case error(error: NetworkError)
}

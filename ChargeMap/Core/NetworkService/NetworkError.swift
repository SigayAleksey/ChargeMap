//
//  NetworkError.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import Foundation

/// Identifier of the cause of the error that occurred for further processing

enum NetworkError: Error {
    case invalidURL
    case invalidRequest
    case networkConnectionLost
    case serverError
    case timedOut
    case unknow
    case unsupportedImage
}

extension NetworkError {
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidRequest:
            return "Invalid request"
        case .networkConnectionLost:
            return "No internet connection"
        case .serverError:
            return "Server error, please try again later"
        case .timedOut:
            return "Service is temporarily unavailable. Please try again later"
        case .unknow:
            return "An unknown error has occurred. Please try again later"
        case .unsupportedImage:
            return "Unsupported image was fetched"
        }
    }
}

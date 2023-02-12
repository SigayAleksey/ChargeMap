//
//  NetworkRequest.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import Foundation

/// Protocol for creating a new reauest
///
/// Required parameters
///  - path;
///  - parameters.

protocol NetworkRequest {
    var apiVersion: String? { get }
    
    var method: HTTPMethod? { get }
    var scheme: URLScheme? { get }
    var host: URLHost? { get }
    var path: String { get }
    var additionalPath: String? { get }
    var parameters: URLParameters? { get }
}

extension NetworkRequest {
    var apiVersion: String? { nil }
    var method: HTTPMethod? { nil }
    var scheme: URLScheme? { nil }
    var host: URLHost? { nil }
    var additionalPath: String? { nil }
}



typealias URLParameters = [String: Any]

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case head = "HEAD"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum URLScheme: String {
    case http = "http"
    case https = "https"
}

enum URLHost: String {
    case productionServer = "api.openchargemap.io"
    case testServer =       ""
}

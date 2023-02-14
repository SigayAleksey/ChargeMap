//
//  RequestFactory.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import Foundation

/// The factory provides creating an URLRequest according to the
/// [API](https://openchargemap.org/site/develop/api#/)

struct RequestFactory {
    
    // MARK: - Properties

    let apiKey: String
    
    // MARK: - Functions
    
    /// Creating an URLRequest according to the API from NetworkRequest protocol
    func create(_ request: NetworkRequest) -> URLRequest? {
        guard let url = url(for: request) else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method?.rawValue ?? HTTPMethod.get.rawValue
        
        return urlRequest
    }
    
    // MARK: - Private functions
    
    private func url(for request: NetworkRequest) -> URL? {
        var components = URLComponents()
        components.scheme = request.scheme?.rawValue ?? URLScheme.https.rawValue
        components.host = request.host?.rawValue ?? URLHost.productionServer.rawValue
        components.path = request.path
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "output", value: "json")
        ]

        guard let parameters = request.parameters else { return components.url }

        for parameter in parameters {
            guard let value = stringValue(from: parameter.value) else {
                continue
            }
            
            components.queryItems?.append(
                URLQueryItem(name: parameter.key, value: value)
            )
        }
        
        return components.url
    }
    
    private func stringValue(from value: Any) -> String? {
        if let stringValue = value as? String {
            return stringValue
        }
        
        if let intValue = value as? Int {
            return String(intValue)
        }
        
        return nil
    }
}

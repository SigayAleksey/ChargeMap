//
//  NetworkService.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import SwiftUI

/// Service for receiving a data from the network
///
/// Use an extension to add a function to receive a response for a new feature

final class NetworkService {
    
    // MARK: - Properties
    
    static let shared = NetworkService()
    
    static let requestFactory = RequestFactory(
        apiKey: "1e2cb9c6-a0e9-4a68-bc09-f3c97a6bd8e4"
    )
    
    // MARK: - Private properties
    
    private let errorHandler = NetworkErrorHandler()
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Functions

    /// Generic function for receiving a data from the network
    func fetchData<T: Decodable>(on request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.serverError
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as DecodingError {
            errorHandler.handleDecodingError(error, for: T.self)
            throw NetworkError.serverError
        }
    }
}


// MARK: - ImageLoading

protocol ImageLoading {
    func fetchImage(url: String) async throws -> any View
    func fetchImage(url: URL) async throws -> any View
}

extension NetworkService: ImageLoading {
    func fetchImage(url: String) async throws -> any View {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        return try await fetchImage(url: url)
    }
    
    func fetchImage(url: URL) async throws -> any View {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.serverError
        }

        guard let uiImage = UIImage(data: data) else {
            throw NetworkError.unsupportedImage
        }

        return Image(uiImage: uiImage)
    }
}

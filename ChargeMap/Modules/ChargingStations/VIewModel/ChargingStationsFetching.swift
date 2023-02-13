//
//  ChargingStationsFetching.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import Foundation

/// Returns the data needed to display ChargingStation on a map
protocol ChargingStationsFetching {
    func fetchChargingStations() async throws -> [ChargingStation]
}

extension NetworkService: ChargingStationsFetching {
    func fetchChargingStations() async throws -> [ChargingStation] {
        guard let request = NetworkService.requestFactory.create(ChargingStationsRequest()) else {
            throw NetworkError.invalidRequest
        }

        return try await NetworkService.shared.fetchData(on: request)
    }
}

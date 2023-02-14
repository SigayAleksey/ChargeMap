//
//  NetworkServiceMock.swift
//  ChargeMapTests
//
//  Created by Alexey Sigay on 13.02.2023.
//

import Foundation
@testable import ChargeMap

class NetworkServiceMock: ChargingStationsFetching {
    var returnValue: [ChargingStation]? = nil
    
    private(set) var fetchChargingStationsWasCalled = false
    private(set) var fetchChargingStationsNumberOfCalls = 0
    func fetchChargingStations() async throws -> [ChargingStation] {
        fetchChargingStationsWasCalled = true
        fetchChargingStationsNumberOfCalls += 1
        
        guard let returnValue = returnValue else {
            throw NetworkError.invalidRequest
        }
        return returnValue
    }
}

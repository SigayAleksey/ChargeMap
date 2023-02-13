//
//  ChargingStationsRequest.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import Foundation

struct ChargingStationsRequest: NetworkRequest {
    var path = "/v3/poi"
    var parameters: URLParameters? = nil
}

//
//  ChargingStation.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import Foundation

struct ChargingStation: Codable, Identifiable, Equatable {
    let id: Int
    let uuid: UUID
    let addressInfo: AddressInfo
    let connections: [Connection]
    let dateLastStatusUpdate: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case uuid = "UUID"
        case addressInfo = "AddressInfo"
        case connections = "Connections"
        case dateLastStatusUpdate = "DateLastStatusUpdate"
    }
}

struct AddressInfo: Codable, Equatable {
    let id: Int
    let title: String
    let address: String
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case title = "Title"
        case address = "AddressLine1"
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
}

struct Connection: Codable, Equatable {
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
    }
}

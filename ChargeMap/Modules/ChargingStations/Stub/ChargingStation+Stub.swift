//
//  ChargingStation.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import Foundation

extension ChargingStation {
    struct Stub {
        static let station1 = ChargingStation(
            id: 1,
            uuid: UUID(),
            addressInfo: AddressInfo(
                id: 1,
                title: "Charging station 1",
                address: "City, Dream street 7",
                latitude: 52.526,
                longitude: 13.415
            ),
            connections: [Connection(id: 1)],
            dateLastStatusUpdate: "2023-02-11T08:42:00Z"
        )
        static let station2 = ChargingStation(
            id: 2,
            uuid: UUID(),
            addressInfo: AddressInfo(
                id: 2,
                title: "Charging station 2",
                address: "City, Sweet street 7",
                latitude: 52,
                longitude: 13
            ),
            connections: [Connection(id: 1), Connection(id: 2)],
            dateLastStatusUpdate: "2023-02-11T08:42:00Z"
        )
        static let station3 = ChargingStation(
            id: 3,
            uuid: UUID(),
            addressInfo: AddressInfo(
                id: 3,
                title: "Charging station 3",
                address: "City, Chocolate street 7",
                latitude: 53,
                longitude: 14
            ),
            connections: [Connection(id: 1), Connection(id: 2), Connection(id: 3)],
            dateLastStatusUpdate: "2023-02-11T08:42:00Z"
        )
        
        static let stations = [station1, station2, station3]
    }
}

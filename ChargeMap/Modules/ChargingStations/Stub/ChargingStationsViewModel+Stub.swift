//
//  ChargingStationsViewModel.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import MapKit

extension ChargingStationsViewModel {
    struct Stub {
        static var coordinateRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 52.526, longitude: 13.415),
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        )
        
        class Error: ChargingStationsViewModelProtocol, MapZoomButtonsProtocol, ErrorViewDelegate {
            @Published private(set) var state: FeatureState<[ChargingStation]> =
                .error(error: NetworkError.serverError)
            @Published var coordinateRegion = Stub.coordinateRegion

            var chargingStations: [ChargingStation] = []

            func getChargingStations() async { }
            
            var repeatableOptions: ErrorViewRepeatableOptions { .repeatable }
            func cancelAction() { }
            func repeatAction() { }
            
            func zoom() { }
            func out() { }
        }
        
        class Empty: ChargingStationsViewModelProtocol, MapZoomButtonsProtocol, ErrorViewDelegate {
            @Published private(set) var state: FeatureState<[ChargingStation]> =
                .success(result: [])
            @Published var coordinateRegion = Stub.coordinateRegion

            var chargingStations: [ChargingStation] = []

            func getChargingStations() async { }
            
            var repeatableOptions: ErrorViewRepeatableOptions { .repeatable }
            func cancelAction() { }
            func repeatAction() { }
            
            func zoom() { }
            func out() { }
        }
        
        class Full: ChargingStationsViewModelProtocol, MapZoomButtonsProtocol, ErrorViewDelegate {
            @Published private(set) var state: FeatureState<[ChargingStation]> =
                .success(result: ChargingStation.Stub.stations)
            @Published var coordinateRegion = Stub.coordinateRegion

            var chargingStations: [ChargingStation] = ChargingStation.Stub.stations

            func getChargingStations() async { }
            
            var repeatableOptions: ErrorViewRepeatableOptions { .repeatable }
            func cancelAction() { }
            func repeatAction() { }
            
            func zoom() { }
            func out() { }
        }
    }
}

//
//  ChargingStationsViewModel.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import Foundation

protocol ChargingStationsViewModelProtocol: ObservableObject {
    /// Status of receiving the data from the network
    var state: FeatureState<[ChargingStation]> { get }
    /// Send network request
    func getChargingStations() async
}

final class ChargingStationsViewModel: ChargingStationsViewModelProtocol {
    
    // MARK: - Properties
    
    @Published private(set) var state: FeatureState<[ChargingStation]> = .none
    
    // MARK: - Private properties
    
    private let networkService: ChargingStationsFetching
    
    // MARK: - Init
    
    init(
        networkService: ChargingStationsFetching
    ) {
        self.networkService = networkService
    }
    
    // MARK: - Functions
    
    func getChargingStations() async {
        DispatchQueue.main.async { self.state = .loading }
        do {
            let chargingStations = try await networkService.fetchChargingStations()
            print(chargingStations.count)
            DispatchQueue.main.async { self.state = .success(result: chargingStations) }
        } catch {
            DispatchQueue.main.async { self.state = .error(error: .serverError) }
        }
    }
}

//
//  ChargingStationsViewModel.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import MapKit

@MainActor
protocol ChargingStationsViewModelProtocol: ObservableObject {
    /// Status of receiving the data from the network
    var state: FeatureState<[ChargingStation]> { get }
    
    var chargingStations: [ChargingStation] { get }
    var coordinateRegion: MKCoordinateRegion { get set }
    var selectedChargingStation: ChargingStation? { get set }
    var showingStationDetails: Bool { get set }
    
    /// Send network request
    func getChargingStations() async
    func chargingStationWasSelected(id: Int)
}

@MainActor
final class ChargingStationsViewModel: ChargingStationsViewModelProtocol {
    
    // MARK: - Properties
    
    @Published private(set) var state: FeatureState<[ChargingStation]> = .none
    @Published var coordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.526, longitude: 13.415),
        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
    )
    @Published var selectedChargingStation: ChargingStation?
    @Published var showingStationDetails = false
    
    var chargingStations: [ChargingStation] {
        switch state {
        case .success(let chargingStations):
            return chargingStations
        default:
            return []
        }
    }
    
    private var refreshTimer: Timer?
    
    // MARK: - Private properties
    
    private let networkService: ChargingStationsFetching
    
    // MARK: - Init
    
    init(networkService: ChargingStationsFetching) {
        self.networkService = networkService
    }
    
    deinit {
        refreshTimer?.invalidate()
    }
    
    // MARK: - Functions
    
    func getChargingStations() async {
        state = .loading
        do {
            let chargingStations = try await networkService.fetchChargingStations()
            state = .success(result: chargingStations)
            setRefreshTimer()
        } catch {
            state = .error(error: .serverError)
        }
    }
    
    func chargingStationWasSelected(id: Int) {
        guard let chargingStation = chargingStations.first(where: { $0.id == id }) else { return }
        selectedChargingStation = chargingStation
        showingStationDetails = true
    }
    
    private func setRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(
            timeInterval: 30,
            target: self,
            selector: #selector(updateChargingStations),
            userInfo: nil,
            repeats: false
        )
    }
    
    @objc private func updateChargingStations() {
        Task { await getChargingStations() }
    }
}

extension ChargingStationsViewModel: ErrorViewDelegate {
    var repeatableOptions: ErrorViewRepeatableOptions { .repeatable }
    
    func cancelAction() {
        state = .none
    }
    
    func repeatAction() {
        Task { await getChargingStations() }
    }
}

extension ChargingStationsViewModel: MapZoomButtonsProtocol {
    func zoom() {
        let latitudeDelta = coordinateRegion.span.latitudeDelta
        let longitudeDelta = coordinateRegion.span.longitudeDelta
        if coordinateRegion.span.latitudeDelta > 0.01,
           coordinateRegion.span.longitudeDelta > 0.01 {
            DispatchQueue.main.async {
                self.coordinateRegion = MKCoordinateRegion(
                    center: self.coordinateRegion.center,
                    span: MKCoordinateSpan(
                        latitudeDelta: self.coordinateRegion.span.latitudeDelta - latitudeDelta*0.3,
                        longitudeDelta: self.coordinateRegion.span.longitudeDelta - longitudeDelta*0.3
                    )
                )
            }
        }
    }
    
    func out() {
        let latitudeDelta = coordinateRegion.span.latitudeDelta
        let longitudeDelta = coordinateRegion.span.longitudeDelta
        if coordinateRegion.span.latitudeDelta < 20,
           coordinateRegion.span.longitudeDelta < 20 {
            DispatchQueue.main.async {
                self.coordinateRegion = MKCoordinateRegion(
                    center: self.coordinateRegion.center,
                    span: MKCoordinateSpan(
                        latitudeDelta: self.coordinateRegion.span.latitudeDelta + latitudeDelta*0.3,
                        longitudeDelta: self.coordinateRegion.span.longitudeDelta + longitudeDelta*0.3
                    )
                )
            }
        }
    }
}

//
//  ChargingStationsViewModelTests.swift
//  ChargeMapTests
//
//  Created by Alexey Sigay on 12.02.2023.
//

import XCTest
import MapKit
@testable import ChargeMap

final class ChargingStationsViewModelTests: XCTestCase {
    
    var networkService = NetworkServiceMock()
    @MainActor
    var viewModel = ChargingStationsViewModel(networkService: NetworkServiceMock())
    
    @MainActor
    override func setUpWithError() throws {
        networkService = NetworkServiceMock()
        viewModel = ChargingStationsViewModel(networkService: networkService)
    }

    override func tearDownWithError() throws {
        
    }
    
    // MARK: - Initial values
    
    @MainActor
    func testInitialValues() throws {
        // then
        XCTAssertEqual(viewModel.state, .none)
        XCTAssertEqual(
            viewModel.coordinateRegion,
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 52.526, longitude: 13.415),
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
            )
        )
        XCTAssertEqual(viewModel.selectedChargingStation, nil)
        XCTAssertEqual(viewModel.showingStationDetails, false)
        XCTAssertTrue(viewModel.chargingStations.isEmpty)
        XCTAssertTrue(viewModel["networkService"] is ChargingStationsFetching)
    }
    
    // MARK: - getChargingStations
    
    @MainActor
    func testArrayOfChargingStationsWasReceived() async throws {
        // given
        XCTAssertEqual(viewModel.state, .none)
        XCTAssertTrue(viewModel.chargingStations.isEmpty)
        XCTAssertFalse(networkService.fetchChargingStationsWasCalled)
        let chargingStations = ChargingStation.Stub.stations
        // when
        networkService.returnValue = chargingStations
        await viewModel.getChargingStations()
        // then
        XCTAssertTrue(networkService.fetchChargingStationsWasCalled)
        XCTAssertEqual(networkService.fetchChargingStationsNumberOfCalls, 1)
        XCTAssertEqual(viewModel.state, .success(result: chargingStations))
        XCTAssertEqual(viewModel.chargingStations, chargingStations)
    }
    
    @MainActor
    func testEmptyArrayOfChargingStationsWasReceived() async throws {
        // given
        XCTAssertEqual(viewModel.state, .none)
        XCTAssertTrue(viewModel.chargingStations.isEmpty)
        XCTAssertFalse(networkService.fetchChargingStationsWasCalled)
        let chargingStations: [ChargingStation] = []
        // when
        networkService.returnValue = chargingStations
        await viewModel.getChargingStations()
        // then
        XCTAssertTrue(networkService.fetchChargingStationsWasCalled)
        XCTAssertEqual(networkService.fetchChargingStationsNumberOfCalls, 1)
        XCTAssertEqual(viewModel.state, .success(result: chargingStations))
        XCTAssertEqual(viewModel.chargingStations, chargingStations)
    }
    
    @MainActor
    func testNoChargingStationWasReceived() async throws {
        // given
        XCTAssertEqual(viewModel.state, .none)
        XCTAssertTrue(viewModel.chargingStations.isEmpty)
        XCTAssertFalse(networkService.fetchChargingStationsWasCalled)
        let chargingStations: [ChargingStation]? = nil
        // when
        networkService.returnValue = chargingStations
        await viewModel.getChargingStations()
        // then
        XCTAssertTrue(networkService.fetchChargingStationsWasCalled)
        XCTAssertEqual(networkService.fetchChargingStationsNumberOfCalls, 1)
        XCTAssertEqual(viewModel.state, .error(error: NetworkError.serverError))
        XCTAssertTrue(viewModel.chargingStations.isEmpty)
    }
    
    // MARK: - chargingStationWasSelected
    
    @MainActor
    func testSetSelectedStation() async throws {
        // given
        networkService.returnValue = ChargingStation.Stub.stations
        await viewModel.getChargingStations()
        let stationID = 1
        // when
        viewModel.chargingStationWasSelected(id: stationID)
        try await Task.sleep(nanoseconds: 1_000)
        // then
        XCTAssertEqual(viewModel.selectedChargingStation, ChargingStation.Stub.station1)
        XCTAssertEqual(viewModel.showingStationDetails, true)
    }
    
    @MainActor
    func testStationWithNonexistentNumberWasSelected() async throws {
        // given
        networkService.returnValue = ChargingStation.Stub.stations
        await viewModel.getChargingStations()
        let stationID = 4
        // when
        viewModel.chargingStationWasSelected(id: stationID)
        try await Task.sleep(nanoseconds: 1_000)
        // then
        XCTAssertEqual(viewModel.selectedChargingStation, nil)
        XCTAssertEqual(viewModel.showingStationDetails, false)
    }

    // MARK: - ErrorViewDelegate
    
    @MainActor
    func testCancelActionShouldSetNoneState() async throws {
        // given
        let chargingStations: [ChargingStation]? = nil
        networkService.returnValue = chargingStations
        await viewModel.getChargingStations()
        XCTAssertTrue(networkService.fetchChargingStationsWasCalled)
        XCTAssertEqual(networkService.fetchChargingStationsNumberOfCalls, 1)
        XCTAssertEqual(viewModel.state, .error(error: NetworkError.serverError))
        XCTAssertTrue(viewModel.chargingStations.isEmpty)
        // when
        viewModel.cancelAction()
        // then
        XCTAssertEqual(networkService.fetchChargingStationsNumberOfCalls, 1)
        XCTAssertEqual(viewModel.state, .none)
    }

    @MainActor
    func testRepeatActionShouldSet() async throws {
        // given
        let chargingStations: [ChargingStation]? = nil
        networkService.returnValue = chargingStations
        await viewModel.getChargingStations()
        XCTAssertTrue(networkService.fetchChargingStationsWasCalled)
        XCTAssertEqual(networkService.fetchChargingStationsNumberOfCalls, 1)
        XCTAssertEqual(viewModel.state, .error(error: NetworkError.serverError))
        XCTAssertTrue(viewModel.chargingStations.isEmpty)
        // when
        viewModel.repeatAction()
        try await Task.sleep(nanoseconds: 1_000_000)
        // then
        XCTAssertEqual(networkService.fetchChargingStationsNumberOfCalls, 2)
    }
    
    // MARK: - MapZoomButtonsProtocol
    
    @MainActor
    func testShouldZoomMap() async throws {
        // given
        let center = CLLocationCoordinate2D(latitude: 50, longitude: 20)
        let coordinateRegion = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        )
        viewModel.coordinateRegion = coordinateRegion
        // when
        viewModel.zoom()
        try await Task.sleep(nanoseconds: 1_000)
        // then
        XCTAssertEqual(viewModel.coordinateRegion.center.latitude, center.latitude)
        XCTAssertEqual(viewModel.coordinateRegion.center.longitude, center.longitude)
        XCTAssertEqual(
            viewModel.coordinateRegion.span.latitudeDelta,
            coordinateRegion.span.latitudeDelta - coordinateRegion.span.latitudeDelta*0.3
        )
        XCTAssertEqual(
            viewModel.coordinateRegion.span.longitudeDelta,
            coordinateRegion.span.longitudeDelta - coordinateRegion.span.longitudeDelta*0.3
        )
    }
    
    @MainActor
    func testShouldOutMap() async throws {
        // given
        let center = CLLocationCoordinate2D(latitude: 50, longitude: 20)
        let coordinateRegion = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
        )
        viewModel.coordinateRegion = coordinateRegion
        // when
        viewModel.out()
        try await Task.sleep(nanoseconds: 1_000)
        // then
        XCTAssertEqual(viewModel.coordinateRegion.center.latitude, center.latitude)
        XCTAssertEqual(viewModel.coordinateRegion.center.longitude, center.longitude)
        XCTAssertEqual(
            viewModel.coordinateRegion.span.latitudeDelta,
            coordinateRegion.span.latitudeDelta + coordinateRegion.span.latitudeDelta*0.3
        )
        XCTAssertEqual(
            viewModel.coordinateRegion.span.longitudeDelta,
            coordinateRegion.span.longitudeDelta + coordinateRegion.span.longitudeDelta*0.3
        )
    }
}

extension ChargingStationsViewModel: PropertyReflectable { }

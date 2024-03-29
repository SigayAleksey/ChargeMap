//
//  ChargingStationsMapView.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import SwiftUI
import MapKit

struct ChargingStationsMapView<ViewModel: ChargingStationsViewModelProtocol & MapZoomButtonsProtocol>: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: ViewModel
    
    // MARK: - View body
    
    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $viewModel.coordinateRegion,
                showsUserLocation: false,
                annotationItems: viewModel.chargingStations
            ) { chargingStation in
                MapAnnotation(
                    coordinate: CLLocationCoordinate2D(
                        latitude: chargingStation.addressInfo.latitude,
                        longitude: chargingStation.addressInfo.longitude
                    )
                ) {
                    MapAnnotationImage()
                        .onTapGesture {
                            viewModel.chargingStationWasSelected(
                                id: chargingStation.id
                            )
                        }
                }
            }
            .ignoresSafeArea()
            .animation(.easeInOut, value: viewModel.coordinateRegion)
            
            MapZoomButtons(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showingStationDetails) {
            if let chargingStation = viewModel.selectedChargingStation {
                ChargingStationDetailsView(chargingStation: chargingStation)
                    .presentationDetents([.height(150)])
                .presentationDragIndicator(.visible)
            }
        }
    }
}

struct ChargingStationsMapView_Previews: PreviewProvider {
    static var previews: some View {
        ChargingStationsMapView(
            viewModel: ChargingStationsViewModel.Stub.Full()
        )
        .previewDisplayName("Full")
        
        ChargingStationsMapView(
            viewModel: ChargingStationsViewModel.Stub.WithStationDetails()
        )
        .previewDisplayName("WithStationDetails")
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
        lhs.span.longitudeDelta == rhs.span.longitudeDelta &&
        lhs.center.latitude == rhs.center.latitude &&
        lhs.center.longitude == rhs.center.longitude
    }
}

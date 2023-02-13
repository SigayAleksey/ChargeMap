//
//  ChargingStationsView.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import SwiftUI
import MapKit

struct ChargingStationsView<ViewModel: ChargingStationsViewModelProtocol & MapZoomButtonsProtocol & ErrorViewDelegate>: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: ViewModel
    
    // MARK: - View body
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .none:
                EmptyView()
            case .loading:
                ProgressView()
            case .success(let chargingStations):
                if !chargingStations.isEmpty {
                    ChargingStationsMapView(viewModel: viewModel)
                } else {
                    Text("There are no charging stations in your area")
                }
            case .error(let error):
                ErrorView(
                    text: error.description,
                    description: nil,
                    delegate: viewModel
                )
            }
        }.task { await viewModel.getChargingStations() }
    }
}

struct ChargingStationsView_Previews: PreviewProvider {
    static var previews: some View {
        ChargingStationsView(viewModel: ChargingStationsViewModel.Stub.Full())
            .previewDisplayName("Full")
        
        ChargingStationsView(viewModel: ChargingStationsViewModel.Stub.Empty())
            .previewDisplayName("Empty")
        
        ChargingStationsView(viewModel: ChargingStationsViewModel.Stub.Error())
            .previewDisplayName("Error")
    }
}

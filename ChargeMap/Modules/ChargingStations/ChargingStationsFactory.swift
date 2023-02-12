//
//  ChargingStationsFactory.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import SwiftUI

struct ChargingStationsFactory {
    @MainActor
    static func create() -> UIViewController {
        let viewModel = ChargingStationsViewModel(
            networkService: NetworkService.shared
        )
        let view = ChargingStationsView(viewModel: viewModel)
        
        return UIHostingController(rootView: view)
    }
}

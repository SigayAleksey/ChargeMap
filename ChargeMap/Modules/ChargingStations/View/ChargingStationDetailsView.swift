//
//  ChargingStationDetailsView.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 13.02.2023.
//

import SwiftUI

struct ChargingStationDetailsView: View {
    
    // MARK: - Properties
    
    let chargingStation: ChargingStation
    
    // MARK: - View body
    
    var body: some View {
        HStack {
            Spacer(minLength: 20)
            VStack(spacing: 16) {
                Text(chargingStation.addressInfo.title)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("📍\(chargingStation.addressInfo.address)")
                        Text("🔋Number of charging points: \(chargingStation.numberOfPoints)")
                    }
                    Spacer()
                }
            }
            Spacer(minLength: 20)
        }
    }
}

struct ChargingStationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ChargingStationDetailsView(
            chargingStation: ChargingStation.Stub.station1
        )
    }
}

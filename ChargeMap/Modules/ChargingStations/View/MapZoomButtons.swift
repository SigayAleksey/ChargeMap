//
//  MapZoomButtons.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import SwiftUI

struct MapZoomButtons<ViewModel: MapZoomButtonsProtocol>: View {
    
    // MARK: - Properties
    
    var viewModel: ViewModel

    // MARK: - View body
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 20) {
                            Button {
                                viewModel.zoom()
                            } label: {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .background(.black.opacity(0.5))
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .clipShape(Circle())
                                    .frame(width: 44, height: 44)
                            }
                            Button {
                                viewModel.out()
                            } label: {
                                Image(systemName: "minus.circle")
                                    .resizable()
                                    .background(.black.opacity(0.5))
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .clipShape(Circle())
                                    .frame(width: 44, height: 44)
                            }
                        }
                    }
                    Spacer(minLength: 20)
                }
            }
            Spacer(minLength: 80)
        }
    }
}

struct MapZoomButtons_Previews: PreviewProvider {
    static var previews: some View {
        MapZoomButtons(viewModel: StubMapZoomer())
    }
}


protocol MapZoomButtonsProtocol {
    func zoom()
    func out()
}

final class StubMapZoomer: MapZoomButtonsProtocol {
    func zoom() { }
    func out() { }
}

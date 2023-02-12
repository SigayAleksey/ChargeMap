//
//  ErrorView.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import SwiftUI

/// View for dispaly an error for user

struct ErrorView: View {
    
    // MARK: - Properties
    
    let text: String
    let description: String?
    let delegate: ErrorViewDelegate?
    
    // MARK: - View body
    
    var body: some View {
        HStack {
            Spacer(minLength: 20)
            VStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text(text)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    if let description = description {
                        Text(description)
                    }
                }
                
                if let delegate = delegate,
                   delegate.repeatableOptions == .repeatable {
                    HStack(spacing: 20) {
                        Button("Cancel", action: delegate.cancelAction)
                        Button("Repeat", action: delegate.repeatAction)
                    }
                    .buttonStyle(.bordered)
                }
                if let delegate = delegate,
                   delegate.repeatableOptions == .noRepeatOption {
                    HStack(spacing: 20) {
                        Button("Cancel", action: delegate.cancelAction)
                    }
                    .buttonStyle(.bordered)
                }
            }
            Spacer(minLength: 20)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(
            text: "Error title error title error title error title",
            description: "Description description description description",
            delegate: StubErrorViewDelegate()
        )
    }
}

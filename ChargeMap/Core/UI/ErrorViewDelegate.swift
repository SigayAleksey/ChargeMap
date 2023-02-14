//
//  ErrorViewDelegate.swift
//  ChargeMap
//
//  Created by Alexey Sigay on 12.02.2023.
//

import Foundation

/// It provides data about ErrorView buttons and their click action
protocol ErrorViewDelegate {
    /// Error view buttons set
    var repeatableOptions: ErrorViewRepeatableOptions { get }
    /// Cancel button action
    func cancelAction()
    /// Repeat button action
    func repeatAction()
}

/// It allows to select different buttons set

struct ErrorViewRepeatableOptions: OptionSet {
    let rawValue: Int
    
    static let repeatable = ErrorViewRepeatableOptions(rawValue: 1 << 0)
    static let noRepeatOption = ErrorViewRepeatableOptions(rawValue: 1 << 1)
}

final class StubErrorViewDelegate: ErrorViewDelegate {
    var repeatableOptions: ErrorViewRepeatableOptions = .repeatable
    func cancelAction() { }
    func repeatAction() { }
}

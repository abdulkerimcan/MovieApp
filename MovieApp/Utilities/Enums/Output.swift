//
//  Output.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 12.05.2024.
//

import Foundation

enum Output {
    case serviceFailed(error: Error)
    case serviceSucceed
    case setLoading(isLoading: Bool)
}

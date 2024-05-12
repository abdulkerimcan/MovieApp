//
//  MovieRequest.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 12.04.2024.
//

import Foundation

struct MovieRequest: Codable {
    let media_type: String?
    let media_id: Int?
    let watchlist: Bool?
}

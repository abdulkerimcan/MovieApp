//
//  Movie.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 10.03.2024.
//

import Foundation

struct MovieRequest: Codable {
    let page: Int
    let results: [MovieResult]
    
}

struct MovieResult: Codable {
    private let backdropPath: String?
    private let genreIDS: [Int]?
    private let id: Int?
    private let originalTitle, overview: String?
    private let posterPath, releaseDate, title: String?
    private let video: Bool?
    private let voteAverage: Double?
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
    }
    
    var _backdropPath: String {
        backdropPath ?? ""
    }
    
    var _id: Int {
        id ?? -1
    }
    
    var _originalTitle: String {
        originalTitle ?? ""
    }
    
    var _overview: String {
        overview ?? ""
    }
    
    var _posterPath: String {
        posterPath ?? ""
    }
    
    var _releaseDate: String {
        releaseDate ?? ""
    }
    
    var _title: String {
        title ?? ""
    }
    
    var _video: Bool {
        video ?? false
    }
    
    var _voteAverage: Double {
        voteAverage ?? 0
    }
}

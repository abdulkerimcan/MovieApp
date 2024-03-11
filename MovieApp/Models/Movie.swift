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
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalTitle, overview: String
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
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
}

//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 10.03.2024.
//

import Foundation



protocol HomeViewModelProtocol {
    var view: HomeViewControllerProtocol? {get set}
    func viewDidLoad()
    func selectMovie(at index: Int)
    func fetchMovies()
}

final class HomeViewModel {
    weak var view: HomeViewControllerProtocol?
    var sections: [HomeSection] = [.discover([Genre(title: "Sci-Fi", imagePath: "scifi"),
                                              Genre(title: "Action", imagePath: "action"),
                                              Genre(title: "Horror", imagePath: "horror")]),
                                   .recommend([Genre(title: "Top Rated Movies", imagePath: "toprated"),
                                               Genre(title: "Upcoming", imagePath: "upcoming")]),
                                   .popular]
    var movies: [MovieResult] = []
    
}

extension HomeViewModel: HomeViewModelProtocol {
    func fetchMovies() {
        view?.startSpinner()
        MovieService.shared.fetchMovies(type: MovieRequest.self, endPoint: .popular) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let success):
                self.view?.stopSpinner()
                let movieResults = success.results
                self.movies.append(contentsOf: movieResults)
                self.view?.reloadData()
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func selectMovie(at index: Int) {
        
    }
    
    func viewDidLoad() {
        fetchMovies()
        view?.configureViewController()
        view?.configureCollectionView()
    }
}

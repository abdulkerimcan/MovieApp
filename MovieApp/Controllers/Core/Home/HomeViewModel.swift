//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 10.03.2024.
//

import Foundation
import Combine

enum HomeViewModelInput {
    case viewDidLoad
}

enum HomeViewModelOutput {
    case serviceFailed(error: Error)
    case serviceSucceed
    case setLoading(isLoading: Bool)
}

protocol HomeViewModelProtocol {
    var view: HomeViewControllerProtocol? {get set}
    func viewDidLoad()
    func selectMovie(at indexPath: IndexPath)
    func fetchMovies()
    func transform(input: AnyPublisher<HomeViewModelInput,Never>) -> AnyPublisher<HomeViewModelOutput, Never>
}

final class HomeViewModel {
    weak var view: HomeViewControllerProtocol?
    var sections: [HomeSection] = [.discover([Genre(title: "Sci-Fi",
                                                    imagePath: "scifi",
                                                    endpoint: .scifi),
                                              Genre(title: "Action",
                                                    imagePath: "action",
                                                    endpoint: .action),
                                              Genre(title: "Horror",
                                                    imagePath: "horror",
                                                    endpoint: .horror)]),
                                   .recommend([Genre(title: "Top Rated Movies",
                                                     imagePath: "toprated",
                                                     endpoint: .topRated),
                                               Genre(title: "Upcoming",
                                                     imagePath: "upcoming",
                                                     endpoint: .upcoming)]),
                                   .popular]
    var movies: [MovieResult] = []

    private let output = PassthroughSubject<HomeViewModelOutput, Never>()
    var cancellables = Set<AnyCancellable>()
    
}

extension HomeViewModel: HomeViewModelProtocol {
    
    func transform(input: AnyPublisher<HomeViewModelInput, Never>) -> AnyPublisher<HomeViewModelOutput, Never> {
        input.sink { event in
            switch event {
            case .viewDidLoad:
                self.fetchMovies()
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    
    func fetchMovies() {
        output.send(.setLoading(isLoading: true))
        MovieService.shared.fetchMovies(endPoint: .popular)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    self.output.send(.setLoading(isLoading: false))
                    self.output.send(.serviceSucceed)
                case .failure(let error):
                    self.output.send(.serviceFailed(error: error))
                }
            } receiveValue: { movieRequest in
                let movieResults = movieRequest.results
                self.movies.append(contentsOf: movieResults)
            }.store(in: &cancellables)
    }
    
    func selectMovie(at indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .popular:
            view?.navigateToDetail(movie: movies[indexPath.item])
        case .discover(let genres):
            let genre = genres[indexPath.item]
            view?.navigateToCategory(genre: genre)
        case .recommend(let genres):
            let genre = genres[indexPath.item]
            view?.navigateToCategory(genre: genre)
        }
    }
    
    func viewDidLoad() {
        view?.bind()
        view?.configureViewController()
        view?.configureCollectionView()
    }
}

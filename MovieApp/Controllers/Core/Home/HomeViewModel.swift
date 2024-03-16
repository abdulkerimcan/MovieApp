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
    func selectMovie(at index: Int)
    func fetchMovies()
    func transform(input: AnyPublisher<HomeViewModelInput,Never>) -> AnyPublisher<HomeViewModelOutput, Never>
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
        MovieService.shared.fetchMovies(type: MovieRequest.self, endPoint: .popular)
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
    
    func selectMovie(at index: Int) {
        
    }
    
    func viewDidLoad() {
        view?.bind()
        view?.configureViewController()
        view?.configureCollectionView()
    }
}

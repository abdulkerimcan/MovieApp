//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 17.03.2024.
//

import Foundation
import Combine

enum MovieListViewModelInput {
    case viewDidLoad
}

enum MovieListViewModelOutput {
    case serviceFailed(error: Error)
    case serviceSucceed
    case setLoading(isLoading: Bool)
}


protocol MovieListViewModelProtocol {
    var view: MovieListViewControllerProtocol? {get set}
    func viewDidLoad()
    func selectMovie(at indexPath: IndexPath)
    func fetchMovies()
    func transform(input: AnyPublisher<MovieListViewModelInput,Never>) -> AnyPublisher<MovieListViewModelOutput,Never>
}

final class MovieListViewModel {
    weak var view: MovieListViewControllerProtocol?
    let endpoint: EndPoint
    var movies:[MovieResult] = []
    private var cancellables = Set<AnyCancellable>()
    private var output = PassthroughSubject<MovieListViewModelOutput,Never>()
    
    //MARK: init -
    init( endpoint: EndPoint) {
        self.endpoint = endpoint
    }
}

extension MovieListViewModel: MovieListViewModelProtocol {
    func selectMovie(at indexPath: IndexPath) {
        view?.navigateToDetail(movie: movies[indexPath.item])
    }
    
    func fetchMovies() {
        output.send(.setLoading(isLoading: true))
        MovieService.shared.fetchMovies(endPoint: endpoint)
            .sink {[unowned self] completion in
                output.send(.setLoading(isLoading: false))
                switch completion {
                case .finished:
                    self.output.send(.serviceSucceed)
                case .failure(let error):
                    self.output.send(.serviceFailed(error: error))
                }
            } receiveValue: {[unowned self] movie in
                self.movies = movie.results
            }.store(in: &cancellables)
        
    }
    
    func transform(input: AnyPublisher<MovieListViewModelInput,Never>) -> AnyPublisher<MovieListViewModelOutput,Never> {
        input.sink {[unowned self] event in
            switch event {
            case .viewDidLoad:
                self.fetchMovies()
            }
        }.store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        view?.configureVC()
        view?.configureCollectionView()
        view?.bind()
    }
}

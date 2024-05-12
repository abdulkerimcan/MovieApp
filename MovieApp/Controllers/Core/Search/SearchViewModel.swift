//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 14.03.2024.
//

import Foundation
import Combine

enum SearchInput {
    case search(query: String)
}

enum SearchOutput {
    case setLoading(isLoading: Bool)
    case serviceSucceed
    case serviceFailed
}

protocol SearchViewModelProtocol {
    var view: SearchViewControllerProtocol? {get set}
    func viewDidLoad()
    func searchMovies(query: String)
    func selectMovie(indexPath: IndexPath)
    func transform(input: AnyPublisher<SearchInput,Never>) -> AnyPublisher<SearchOutput,Never>
}

final class SearchViewModel {
    weak var view: SearchViewControllerProtocol?
    var cancellable = Set<AnyCancellable>()
    var movies: [MovieResult] = []
    var output = PassthroughSubject<SearchOutput,Never>()
}

extension SearchViewModel: SearchViewModelProtocol {
    func selectMovie(indexPath: IndexPath) {
        view?.navigateToDetail(movie: movies[indexPath.item])
    }
    
    func transform(input: AnyPublisher<SearchInput, Never>) -> AnyPublisher<SearchOutput, Never> {
        input.sink { [unowned self] input in
            switch input {
            case .search(let query):
                self.searchMovies(query: query)
            }
        }.store(in: &cancellable)
        return output.eraseToAnyPublisher()
    }
    
    func searchMovies(query: String) {
        output.send(.setLoading(isLoading: true))
        MovieService.shared.searchMovie(query: query)
            .sink { [unowned self] completion in
                switch completion {
                case .finished:
                    self.output.send(.serviceSucceed)
                    self.output.send(.setLoading(isLoading: false))
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                    self.output.send(.serviceFailed)
                }
            } receiveValue: { movieRequest in
                let moviesResults = movieRequest.results.compactMap { $0._posterPath.isEmpty ? nil : $0 }
                self.movies = moviesResults
                
            }.store(in: &cancellable)
    }
    
    func viewDidLoad() {
        view?.configureVC()
        view?.configureCollectionView()
        view?.bind()
    }
}

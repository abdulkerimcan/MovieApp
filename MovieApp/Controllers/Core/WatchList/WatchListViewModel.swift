//
//  WatchListViewModel.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 18.03.2024.
//

import Foundation
import Combine

protocol WatchListViewModelProtocol {
    var view: WatchListViewControllerProtocol? {get set}
    func viewDidLoad()
    func fetchMovies()
    func transform(_ input: AnyPublisher<Input,Never>) -> AnyPublisher<Output,Never>
}

final class WatchListViewModel {
    weak var view: WatchListViewControllerProtocol?
    private var cancellables = Set<AnyCancellable>()
    var output = PassthroughSubject<Output,Never>()
    var movies:[MovieResult] = []
}

extension WatchListViewModel: WatchListViewModelProtocol {
    func fetchMovies() {
        MovieService.shared.fetchMovies(endPoint: .watchList)
            .sink { [unowned self] event in
                switch event {
                case .failure(let error):
                    self.output.send(.serviceFailed(error: error))
                case .finished:
                    self.output.send(.serviceSucceed)
                }
            } receiveValue: { movieResponse in
                self.movies.removeAll()
                self.movies.append(contentsOf: movieResponse.results)
            }.store(in: &cancellables)
    }
    
    func transform(_ input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink {[unowned self] event in
            switch event {
            case .viewDidLoad:
                break
            case .viewWillAppear:
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

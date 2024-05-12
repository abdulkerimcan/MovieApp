//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 16.03.2024.
//

import Foundation
import Combine

protocol MovieDetailViewModelProtocol {
    var view: MovieDetailViewControllerProtocol? {get set}
    func viewDidLoad()
    func viewDidLayoutSubviews()
    func addWatchList(movie: MovieResult)
}

final class MovieDetailViewModel {
    private var cancellable = Set<AnyCancellable>()
    weak var view: MovieDetailViewControllerProtocol?
}

extension MovieDetailViewModel: MovieDetailViewModelProtocol {
    
    func addWatchList(movie: MovieResult) {
        MovieService.shared.addWatchList(movie: movie)
            .sink { event in
                switch event {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                print(response.status_message)
            }.store(in: &cancellable)
    }
    
    func viewDidLayoutSubviews() {
        view?.configureGradientFrame()
    }
    
    func viewDidLoad() {
        view?.configureVC()
        view?.configureGradient()
    }
}

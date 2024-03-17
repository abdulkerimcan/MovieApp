//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 16.03.2024.
//

import Foundation

protocol MovieDetailViewModelProtocol {
    var view: MovieDetailViewControllerProtocol? {get set}
    func viewDidLoad()
}

final class MovieDetailViewModel {
    weak var view: MovieDetailViewControllerProtocol?
}

extension MovieDetailViewModel: MovieDetailViewModelProtocol {
    func viewDidLoad() {
        view?.configureVC()
    }
}

//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 16.03.2024.
//

import UIKit

protocol MovieDetailViewControllerProtocol: AnyObject {
    func configureVC()
}

final class MovieDetailViewController: UIViewController {
    
    private lazy var movieInformationView: MovieInformationView = {
        let movieView = MovieInformationView(frame: .zero)
        movieView.translatesAutoresizingMaskIntoConstraints = false
        return movieView
    }()
    var movie: MovieResult
    
    var viewModel: MovieDetailViewModel
    
    init(movie: MovieResult, viewModel: MovieDetailViewModel) {
        self.movie = movie
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
}

extension MovieDetailViewController: MovieDetailViewControllerProtocol {
    func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubview(movieInformationView)
        NSLayoutConstraint.activate([
            movieInformationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieInformationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieInformationView.topAnchor.constraint(equalTo: view.topAnchor),
            movieInformationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        movieInformationView.configure(with: movie)
    }
}

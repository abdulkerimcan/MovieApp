//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 17.03.2024.
//

import UIKit
import Combine

protocol MovieListViewControllerProtocol: AnyObject {
    func configureVC()
    func configureCollectionView()
    func bind()
    func navigateToDetail(movie: MovieResult)
    func reloadData()
    func startSpinner()
    func stopSpinner()
}

final class MovieListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(frame: .zero)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .large
        return spinner
    }()
    
    private var viewModel: MovieListViewModel
    
    private var genreTitle: String
    
    private var cancellables = Set<AnyCancellable>()
    
    private var input = PassthroughSubject<Input,Never>()
    
    init(genreTitle: String,viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        self.genreTitle = genreTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        viewModel.view = self
        viewModel.viewDidLoad()
        input.send(.viewDidLoad)
        super.viewDidLoad()
    }
}

extension MovieListViewController: MovieListViewControllerProtocol {
    func navigateToDetail(movie: MovieResult) {
        DispatchQueue.main.async {
            let vc = MovieDetailViewController(movie: movie, viewModel: MovieDetailViewModel())
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func startSpinner() {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }
    
    func stopSpinner() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.sink {[unowned self] event in
            switch event {
            case .serviceFailed(let error):
                print(error)
            case .serviceSucceed:
                self.reloadData()
            case .setLoading(let isLoading):
                isLoading ? self.startSpinner() : self.stopSpinner()
            }
        }.store(in: &cancellables)
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.addSubview(spinner)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
        ])
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = genreTitle
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectMovie(at: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            fatalError()
        }
        cell.configureCell(with: viewModel.movies[indexPath.item])
        return cell
    }
    
}

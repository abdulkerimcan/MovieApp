//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 10.03.2024.
//

import UIKit
import Combine

protocol HomeViewControllerProtocol: AnyObject {
    func configureViewController()
    func configureCollectionView()
    func navigateToDetail(movie: MovieResult)
    func navigateToCategory(genre: Genre)
    func startSpinner()
    func stopSpinner()
    func reloadData()
    func bind()
}

final class HomeViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(frame: .zero)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .large
        return spinner
    }()
    
    var viewModel: HomeViewModel
    
    var cancellables = Set<AnyCancellable>()
    let input = PassthroughSubject<HomeViewModelInput,Never>()
    
    init(viewModel: HomeViewModel) {
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
        input.send(.viewDidLoad)
    }
}

//MARK: - HomeViewControllerProtocol functions

extension HomeViewController: HomeViewControllerProtocol {
    func navigateToCategory(genre: Genre) {
        DispatchQueue.main.async {
            let vc = MovieListViewController(genreTitle: genre.title,viewModel: MovieListViewModel(endpoint: genre.endpoint))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToDetail(movie: MovieResult) {
        DispatchQueue.main.async {
            let vc = MovieDetailViewController(movie: movie, viewModel: MovieDetailViewModel())
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] state in
            switch state {
            case .serviceFailed(let error):
                print(error.localizedDescription)
            case .serviceSucceed:
                self.reloadData()
            case .setLoading(let isLoading):
                isLoading ? self.startSpinner() : self.stopSpinner()
            }
        }.store(in: &cancellables)
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
    
    func configureCollectionView() {
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout(viewModel: viewModel))
        self.view.addSubviews(collectionView)
        self.collectionView.addSubview(spinner)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(HomeHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeaderCollectionReusableView.identifier)
        collectionView.register(HomeCollectionGenreCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionGenreCollectionViewCell.identifier)
        collectionView.register(HomeMovieCollectionViewCell.self, forCellWithReuseIdentifier: HomeMovieCollectionViewCell.identifier)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
        ])
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
}

//MARK: - CollectionView functions

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: .deviceWidth, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionType = viewModel.sections[indexPath.section]
        guard let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeaderCollectionReusableView.identifier, for: indexPath) as? HomeHeaderCollectionReusableView else {
            fatalError()
        }
        switch sectionType{
        case .discover(_):
            reusableView.configure(with: "Discover New Movies")
        case .recommend(_):
            reusableView.configure(with: "Recommended For You")
        case .popular:
            reusableView.configure(with: "Popular Movies")
        }
        
        return reusableView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectMovie(at: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = viewModel.sections[section]
        switch section {
        case .discover(let items):
            return items.count
        case .recommend(let items):
            return items.count
        case .popular:
            return viewModel.movies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        
        switch sectionType {
        case .discover(let items):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionGenreCollectionViewCell.identifier, for: indexPath) as? HomeCollectionGenreCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: items[indexPath.item])
            return cell
            
        case .recommend(let items):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionGenreCollectionViewCell.identifier, for: indexPath) as? HomeCollectionGenreCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: items[indexPath.item])
            return cell
        case .popular:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMovieCollectionViewCell.identifier, for: indexPath) as? HomeMovieCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel.movies[indexPath.item])
            return cell
        }
    }
}

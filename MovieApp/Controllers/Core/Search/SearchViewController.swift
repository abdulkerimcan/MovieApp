//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 14.03.2024.
//

import UIKit
import Combine

protocol SearchViewControllerProtocol: AnyObject {
    func configureVC()
    func configureCollectionView()
    func startSpinner()
    func stopSpinner()
    func bind()
}

final class SearchViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(frame: .zero)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .large
        return spinner
    }()
    
    var viewModel: SearchViewModel
    
    var cancellable = Set<AnyCancellable>()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var input = PassthroughSubject<SearchInput,Never>()
    
    //MARK: init
    init(viewModel: SearchViewModel) {
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

extension SearchViewController: SearchViewControllerProtocol {
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
    
    func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                case .serviceSucceed:
                    self.collectionView.reloadData()
                    break
                case .serviceFailed:
                    break
                case .setLoading(let isLoading):
                    isLoading ? self.startSpinner() : self.stopSpinner()
                }
            }.store(in: &cancellable)
    }
    
    func configureVC() {
        title = "Search Movies"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.addSubview(spinner)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
        ])
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            fatalError()
        }
        cell.configureCell(with: viewModel.movies[indexPath.item])
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        input.send(.search(query: searchText))
    }
}

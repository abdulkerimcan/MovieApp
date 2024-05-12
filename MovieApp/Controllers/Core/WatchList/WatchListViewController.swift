//
//  WatchListViewController.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 14.03.2024.
//

import UIKit
import Combine

protocol WatchListViewControllerProtocol: AnyObject {
    func configureVC()
    func configureCollectionView()
    func bind()
    func reloadData()
}

final class WatchListViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    private var collectionView: UICollectionView!
    
    private var input = PassthroughSubject<Input,Never>()
    
    private var viewModel: WatchListViewModel
    
    init(viewModel: WatchListViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.send(.viewWillAppear)
    }
}

extension WatchListViewController: WatchListViewControllerProtocol {
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    func bind() {
        let output = viewModel.transform(input.eraseToAnyPublisher())
        
        output.sink { [unowned self] event in
            switch event {
            case .serviceFailed(let error):
                print(error)
            case .serviceSucceed:
                reloadData()
            case .setLoading(let isLoading):
                break
            }
        }.store(in: &cancellables)

    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
    }
    
    func configureVC() {
        
    }
}

extension WatchListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(viewModel.movies.count)
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            fatalError()
        }
        cell.configureCell(with: viewModel.movies[indexPath.item])
        return cell
    }
    
    
}

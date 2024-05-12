//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 16.03.2024.
//

import UIKit
import Combine

protocol MovieDetailViewControllerProtocol: AnyObject {
    func configureVC()
    func configureGradient()
    func configureGradientFrame()
}

final class MovieDetailViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var overviewLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "star.circle.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var voteAverageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private var movie: MovieResult
    
    private var viewModel: MovieDetailViewModel
    
    private let gradientLayer = CAGradientLayer()
    
    private var cancellable = Set<AnyCancellable>()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
    
    @objc func didTapPlayButton() {
        viewModel.addWatchList(movie: movie)
    }
}

extension MovieDetailViewController: MovieDetailViewControllerProtocol {
    func configureGradientFrame() {
        gradientLayer.frame = imageView.bounds
    }
    
    func configureGradient() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        imageView.layer.addSublayer(gradientLayer)
    }
    
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        view.addSubviews(imageView,
                        titleLabel,
                        playButton,
                        starImageView,
                        voteAverageLabel,
                        overviewLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            starImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            starImageView.heightAnchor.constraint(equalToConstant: 30),
            starImageView.widthAnchor.constraint(equalToConstant: 30),
            starImageView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: starImageView.topAnchor, constant: -10),
            
            voteAverageLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 2),
            voteAverageLabel.topAnchor.constraint(equalTo: starImageView.topAnchor),
            voteAverageLabel.bottomAnchor.constraint(equalTo: starImageView.bottomAnchor),
            
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            playButton.bottomAnchor.constraint(equalTo: starImageView.bottomAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            
        ])
        
        ImageCacheManager.shared.loadImage(urlString: movie._backdropPath)
            .sink { [unowned self] image in
                self.imageView.image = image
            }.store(in: &cancellable)
        
        let voteValue = (movie._voteAverage * 10).rounded() / 10
        voteAverageLabel.text = "\(voteValue)"
        titleLabel.text = movie._title
        overviewLabel.text = movie._overview
    }
}

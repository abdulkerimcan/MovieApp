//
//  HomeMovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 10.03.2024.
//

import UIKit
import Combine

final class HomeMovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeMovieCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "action")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "Inception"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var playImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.image = UIImage(systemName: "play.circle")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.image = UIImage(systemName: "star.circle.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var voteAverageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubviews(imageView,
                    titleLabel,
                    playImageView,
                    starImageView,
                    voteAverageLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            
            playImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            playImageView.heightAnchor.constraint(equalToConstant: 40),
            playImageView.widthAnchor.constraint(equalToConstant: 40),
            
            starImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            starImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            starImageView.heightAnchor.constraint(equalToConstant: 30),
            starImageView.widthAnchor.constraint(equalToConstant: 30),
            
            voteAverageLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 2),
            voteAverageLabel.topAnchor.constraint(equalTo: starImageView.topAnchor),
            voteAverageLabel.bottomAnchor.constraint(equalTo: starImageView.bottomAnchor),
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.makeRounded()
    }
    
    func configure(with movie: MovieResult) {
        MovieService.shared.downloadImage(from: movie.backdropPath)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { data in
                let image = UIImage(data: data)
                self.imageView.image = image
            }.store(in: &cancellables)

        titleLabel.text = movie.title
        let voteValue = (movie.voteAverage * 10).rounded() / 10
        voteAverageLabel.text = "\(voteValue)"
    }
}

//
//  MovieInformationView.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 17.03.2024.
//

import UIKit
import Combine

final class MovieInformationView: UIView {
    
    var cancellable = Set<AnyCancellable>()
    
    private let gradientLayer = CAGradientLayer()
    
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
    
    private lazy var playListImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play.circle.fill")
        imageView.tintColor = .main
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var overviewLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = imageView.bounds
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        addSubviews(imageView,
                    titleLabel,
                    playListImageView,
                    starImageView,
                    voteAverageLabel,
                    overviewLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -25),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            
            starImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            starImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            starImageView.heightAnchor.constraint(equalToConstant: 30),
            starImageView.widthAnchor.constraint(equalToConstant: 30),
            
            voteAverageLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 2),
            voteAverageLabel.topAnchor.constraint(equalTo: starImageView.topAnchor),
            voteAverageLabel.bottomAnchor.constraint(equalTo: starImageView.bottomAnchor),
            
            playListImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            playListImageView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            playListImageView.bottomAnchor.constraint(equalTo: starImageView.bottomAnchor),
            playListImageView.heightAnchor.constraint(equalToConstant: 50),
            playListImageView.widthAnchor.constraint(equalToConstant: 50),
            
            overviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            
        ])
    }
    
    func configure(with movie: MovieResult) {
        ImageCacheManager.shared.loadImage(urlString: movie._backdropPath)
            .sink { [unowned self] image in
                self.imageView.image = image
            }.store(in: &cancellable)
        let voteValue = (movie._voteAverage * 10).rounded() / 10
        voteAverageLabel.text = "\(voteValue)"
        titleLabel.text = movie._title
        overviewLabel.text = movie._overview
    }
    
    private func setupGradient() {
           gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
           gradientLayer.locations = [0.0, 1.0]
           imageView.layer.addSublayer(gradientLayer)
       }
}

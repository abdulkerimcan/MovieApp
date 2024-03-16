//
//  SearchMovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 16.03.2024.
//

import UIKit
import Combine

final class SearchMovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchMovieCollectionViewCell"
    
    private let gradientLayer = CAGradientLayer()
    
    var cancellable = Set<AnyCancellable>()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.titleLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = imageView.bounds
    }
    
    private func setupUI() {
        addSubviews(imageView,
                    titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    func configureCell(with movie: MovieResult) {
        titleLabel.text = movie._title
        ImageCacheManager.shared.loadImage(urlString: movie._posterPath)
            .sink { [unowned self] image in
                self.imageView.image = image
            }
            .store(in: &cancellable)
    }
    
    private func setupGradient() {
           gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
           gradientLayer.locations = [0.0, 1.0]
           imageView.layer.addSublayer(gradientLayer)
       }
}

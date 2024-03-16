//
//  HomeCollectionViewCell.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 10.03.2024.
//

import UIKit

final class HomeCollectionGenreCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeCollectionGenreCollectionViewCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView(frame: bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .main.withAlphaComponent(0.7)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubviews(imageView, overlayView,titleLabel)
        self.bringSubviewToFront(titleLabel)
        titleLabel.layer.zPosition = .greatestFiniteMagnitude
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
        ])
    }
    
    func configure(with genre: Genre) {
        let image = UIImage(named: genre.imagePath)
        DispatchQueue.main.async {
            self.imageView.image = image
        }
        self.titleLabel.text = genre.title
    }
}

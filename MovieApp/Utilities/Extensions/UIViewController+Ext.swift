//
//  UIViewController+Ext.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 10.03.2024.
//

import UIKit

extension UIViewController {
    func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let itemWidth = (CGFloat.deviceWidth - 30)/2
        layout.itemSize = CGSize(width: itemWidth, height: .deviceHeight * 1.5)
        return layout
    }
    
    func createCompositionalLayout(viewModel: HomeViewModel) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSectionLayout(viewModel: viewModel, for: sectionIndex)
        }
        return layout
    }
    
    private func createSectionLayout(viewModel: HomeViewModel, for sectionIndex: Int) -> NSCollectionLayoutSection {
        let sectionType = viewModel.sections[sectionIndex]
        
        switch sectionType {
        case .discover:
            return createDiscoverLayout()
        case .popular:
            return createPopularLayout()
        case .recommend:
            return createRecommendLayout()
        }
    }
    private func createDiscoverLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.33),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 4,
            bottom: 2,
            trailing: 4
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize:  NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item, item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func createRecommendLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 10,
            bottom: 2,
            trailing: 10
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize:  NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item, item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func createPopularLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize:  NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(100)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
        
    }
}


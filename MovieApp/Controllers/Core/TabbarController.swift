//
//  UITabBarController.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 14.03.2024.
//

import UIKit

final class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.tintColor = .label
        setupTabs()
    }
    
    private func setupTabs() {
        let navs = [createHomeTab(),createSearchTab(),createWatchListTab()]
        setViewControllers(navs, animated: true)
    }
}

private extension TabbarController {
    func createHomeTab() -> UINavigationController {
        let vc = HomeViewController(viewModel: HomeViewModel())
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        return nav
    }
    
    func createSearchTab() -> UINavigationController {
        let vc = SearchViewController(viewModel: SearchViewModel())
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        return nav
    }
    
    func createWatchListTab() -> UINavigationController {
        let vc = WatchListViewController(viewModel: WatchListViewModel())
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem = UITabBarItem(title: "Watch List", image: UIImage(systemName: "play.tv"), tag: 2)
        return nav
    }
}

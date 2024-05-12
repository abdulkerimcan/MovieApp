//
//  AlertPresentable.swift
//  MovieApp
//
//  Created by Abdulkerim Can on 12.05.2024.
//

import UIKit

protocol AlertPresentable {
    func showAlert(title: String?, message: String?, action: @escaping () -> Void )
}

extension AlertPresentable where Self: UIViewController {
    func showAlert(title: String?, message: String?, action: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            action()
        }
        alertController.addAction(action)
        
        
        present(alertController, animated: true)

    }
}

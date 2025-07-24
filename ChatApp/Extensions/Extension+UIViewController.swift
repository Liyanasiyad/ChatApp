//
//  Extension+UIViewController.swift
//  ChatApp
//
//  Created by Liyana on 23/07/25.
//

import Foundation
import UIKit
extension UIViewController {
    func presentErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
        
        
        
    }
}

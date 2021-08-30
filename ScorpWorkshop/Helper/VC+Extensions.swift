//
//  VC+Extensions.swift
//  ScorpWorkshop
//
//  Created by Kaan Ozdemir on 30.08.2021.
//  Copyright © 2021 Kaan Ozdemir. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actions.forEach { action in
            alertController.addAction(action)
        }
        
        present(alertController, animated: true)
    }
    
    var activityIndicatorView: UIActivityIndicatorView? {
        if let subView = view.subviews.first(where: { $0.tag == 99999 }) {
            view.bringSubviewToFront(subView)
            return subView as? UIActivityIndicatorView
        }
        
        let activityIndicatorView = UIActivityIndicatorView(frame: view.frame)
        activityIndicatorView.tag = 99999
        activityIndicatorView.tintColor = .orange
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.backgroundColor = UIColor(white: 1, alpha: 0.7)
        if #available(iOS 13.0, *) {
            activityIndicatorView.style = .medium
        } else {
            activityIndicatorView.style = .gray
        }
        view.addSubview(activityIndicatorView)
        view.bringSubviewToFront(activityIndicatorView)
        
        return activityIndicatorView
    }
    
    func startLoading() {
        activityIndicatorView?.startAnimating()
    }
    
    func stopLoading() {
        activityIndicatorView?.stopAnimating()
    }
}

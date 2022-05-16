//
//  UIViewControllerExtension.swift
//  TestMovies
//
//  Created by Natalia on 16.05.2022.
//

import UIKit
import Alamofire

extension UIViewController {
    func showAlertError() {
        let alertController = UIAlertController(
            title: "Ошибка!",
            message: "Не удалось загрузить страницу",
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(
            title: "OK",
            style: .cancel
        )

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }

    func setupBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        navigationController?.navigationBar.tintColor = .orange
    }

    func setupTitleController(title: String?) {
        navigationItem.title = title ?? ""
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
    }
}

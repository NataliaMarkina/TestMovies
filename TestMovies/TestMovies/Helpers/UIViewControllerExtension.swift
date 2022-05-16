//
//  UIViewControllerExtension.swift
//  TestMovies
//
//  Created by Natalia on 16.05.2022.
//

import UIKit

extension UIViewController {

    private static let association = ObjectAssociation<UIActivityIndicatorView>()

    var indicator: UIActivityIndicatorView {
        set { UIViewController.association[self] = newValue }
        get {
            if let indicator = UIViewController.association[self] {
                return indicator
            } else {
                UIViewController.association[self] = UIActivityIndicatorView.customIndicator(at: self.view.center)
                return UIViewController.association[self]!
            }
        }
    }

    var safeAreaInsets: UIEdgeInsets? {
        return UIApplication.shared.keyWindow?.safeAreaInsets
    }

    var insets: UIEdgeInsets {
        let safeArea = safeAreaInsets ?? .zero
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let insets: UIEdgeInsets = .init(
            top: safeArea.top + navBarHeight,
            left: safeArea.left,
            bottom: safeArea.bottom,
            right: safeArea.right
        )
        return insets
    }

    func startIndicatingActivity() {
        DispatchQueue.main.async {
            self.view.addSubview(self.indicator)
            self.indicator.startAnimating()
        }
    }

    func stopIndicatingActivity() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
        }
    }

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

extension UIActivityIndicatorView {
    public static func customIndicator(at center: CGPoint) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        indicator.center = center
        indicator.hidesWhenStopped = true
        return indicator
    }
}

public final class ObjectAssociation<T: AnyObject> {

    private let policy: objc_AssociationPolicy

    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {

        self.policy = policy
    }

    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {
        // swiftlint:disable force_cast
        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}

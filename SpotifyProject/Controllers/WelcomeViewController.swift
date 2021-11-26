//
//  WelcomeViewController.swift
//  SpotifyProject
//
//  Created by Pelayo Mercado on 11/10/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .tintColor
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "background-image")
        return imageView
    }()
    
    private let overlayView: UIView = {
        let uiview = UIView()
        uiview.backgroundColor = .blue
        uiview.alpha = 0.5
        return uiview
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Listen to millions of Songs on the go"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
       // view.addSubview(overlayView)
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        view.addSubview(label)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
        //overlayView.frame = view.bounds
        signInButton.frame = CGRect(x: 20,
                                    y: view.height-view.safeAreaInsets.bottom-50,
                                    width: view.width-40 ,
                                    height: 50)
        label.frame = CGRect(x: 30, y: (view.width+700)/2, width: view.width-60, height: 150)
        
    }
    
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        print("pressed")
    }
    
    private func handleSignIn(success: Bool) {
        // Log user in or yell at them for error
        
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true, completion: nil)
    }

}

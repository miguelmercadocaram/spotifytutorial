//
//  PlayerViewController.swift
//  SpotifyProject
//
//  Created by Pelayo Mercado on 11/23/21.
//

import UIKit
import SDWebImage
import AudioToolbox

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
}
class PlayerViewController: UIViewController {
    
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let controlView = PlayerControlView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlView)
        configureBarButtons()
        controlView.delegate = self
        configure()
        
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controlView.frame = CGRect(x: 10, y: imageView.bottom+10, width: view.width-20, height: view.height-imageView.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-15)
    }
    
    private func configure() {
        controlView.configure(with: PlayerControlsViewViewModel(title: dataSource?.songName, subtitle: dataSource?.subtitle))
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
    }
    
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func refreshUI() {
        configure()
    }

}

extension PlayerViewController: PlayerControlsViewDelegate {
   
    
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlView) {
        delegate?.didTapPlayPause()
    }
    
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlView) {
        delegate?.didTapForward()
    }
    
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlView) {
        delegate?.didTapBackward()
    }
    func playerControlsView(_ playerControlsView: PlayerControlView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    
}

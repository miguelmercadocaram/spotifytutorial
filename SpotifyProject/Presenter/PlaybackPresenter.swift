//
//  PlaybackPresenter.swift
//  SpotifyProject
//
//  Created by Pelayo Mercado on 11/23/21.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
    
}

struct PlayerControlsViewViewModel {
    let title: String?
    let subtitle: String?
}
final class PlaybackPresenter {
    var index = 0
    static let shared = PlaybackPresenter()
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        }else if let player = self.playerQueue, !tracks.isEmpty {
            return tracks[index]
        }
        return nil
    }
    
    var playerVC: PlayerViewController?
    
     func startPlayback(from viewController: UIViewController, track: AudioTrack) {
         guard let url = URL(string: track.preview_url ?? "-") else {
             return
         }
        player = AVPlayer(url: url)
         
         
        let vc = PlayerViewController()
        vc.title = track.name
         self.track = track
         self.tracks = []
         vc.dataSource = self
         vc.delegate = self
         viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
             self?.player?.play()
         }
         self.playerVC = vc
    }
    
     func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]) {
         
         self.tracks = tracks
         self.track = nil
         
         print(tracks)
         
         self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
             
             guard let url = URL(string: $0.preview_url ?? "") else {
                 return nil
             }
             return AVPlayerItem(url: url)
             
         }))
         
         self.playerQueue?.play()
         
        let vc = PlayerViewController()
         vc.dataSource = self
         vc.delegate = self
         viewController.present(vc, animated: true, completion: nil)
         self.playerVC = vc
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }else if player.timeControlStatus == .paused {
                player.play()
            }
        }
        else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            }else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
   
    
  
    
    func didTapForward() {
        if tracks.isEmpty {
            // not playlist or album
            player?.pause()
        }
        else if let player = playerQueue {

            player.advanceToNextItem()
            index += 1
            print(index)
            playerVC?.refreshUI()
        }
    }

    func didTapBackward() {
        if tracks.isEmpty {
            // not playlist or album
            player?.pause()
            player?.play()
        }else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
        }
    }
    
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
    
    
}

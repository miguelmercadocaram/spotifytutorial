//
//  LibraryAlbumsViewController.swift
//  SpotifyProject
//
//  Created by Pelayo Mercado on 11/25/21.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {

    var albums = [Album]()
    
    private let noAlbumsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultsSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultsSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    private var observer: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        setupNoAlbumsView()
        fetchData()
        tableView.delegate = self
        tableView.dataSource = self
        observer = NotificationCenter.default.addObserver(forName: .albumSavedNotification, object: nil, queue: .main, using: { [weak self]_ in
            self?.fetchData()
        })
      
    }
    
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupNoAlbumsView() {
        view.addSubview(noAlbumsView)
        noAlbumsView.delegate = self
        noAlbumsView.configure(with: ActionLabelViewViewModel(text: "You dont have any albums", actionTitle: "Browse"))
    }
    
    private func fetchData() {
        albums.removeAll()
        APICaller.shared.getCurrentUserAlbum { [weak self] result in
            switch result {
            case .success(let albums):
                self?.albums = albums
                self?.updateUI()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(x: (view.width-150)/2, y: (view.height-150)/2, width: 150, height: 150)
        tableView.frame = view.bounds
    }
    
    private func updateUI() {
        if albums.isEmpty {
            // Show label
            DispatchQueue.main.async {
                self.noAlbumsView.isHidden = false
                self.tableView.isHidden = true
            }
          
        }else {
            // Show table
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.noAlbumsView.isHidden = true
                self.tableView.isHidden = false
            }
          
        }
    }



}

extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
    
    
}

extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultsSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultsSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let album = albums[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: album.name, subtitle: album.artists.first?.name ?? "-", imageURL: URL(string: album.images.first?.url ?? "")))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        tableView.deselectRow(at: indexPath, animated: true)
        let album = albums[indexPath.row]
     
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

   

}

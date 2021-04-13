//
//  FavoritesViewController.swift
//  MusicApp
//
//  Created by Ravi Patel on 4/12/21.
//

import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet weak var favoritesAlbumTableView: UITableView!
    
    var favoritedAlbums: [MusicAlbum] = [MusicAlbum]()
    let networkClient = NetworkClient()
    var selectedAlbum: MusicAlbum?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favoritesAlbumTableView.delegate = self
        favoritesAlbumTableView.dataSource = self
        favoritesAlbumTableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(addedAlbumToFavorites), name: Notification.Name.FAVORITES_ADDED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removedAlbumFromFavorites(notification:)), name: Notification.Name.FAVORITES_REMOVED, object: nil)
    }
    
    @objc func addedAlbumToFavorites(notification: NSNotification){
        if let musicAlbum = notification.userInfo?["Album"] as? MusicAlbum {
            favoritedAlbums.append(musicAlbum)
            favoritesAlbumTableView.reloadData()
        }
    }
    
    @objc func removedAlbumFromFavorites(notification: NSNotification){
        if let musicAlbum = notification.userInfo?["Album"] as? MusicAlbum {
            favoritedAlbums = favoritedAlbums.filter({$0 !== musicAlbum})
            favoritesAlbumTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AlbumDetailViewController
        destination.album = selectedAlbum
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritedAlbums.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! MusicAlbumTableViewCell
        let album = favoritedAlbums[indexPath.row]
        cell.artistName.text = album.artistName
        cell.albumName.text = album.name
        cell.accessoryView?.tintColor = UIColor.FAVORITES_COLOR
        
        let artworkURL = URL(string: album.artworkUrl100 ?? "")!
        networkClient.getAlbumArtwork(fromURL: artworkURL) { (image) in
            if let image = image{
                cell.albumArt.image = image
            }
            else{
                cell.albumArt.image = UIImage(named: "MissingArt")

            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAlbum = favoritedAlbums[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetails", sender: nil)
    }
}

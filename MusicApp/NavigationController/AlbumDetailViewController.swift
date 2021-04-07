//
//  AlbumDetailViewController.swift
//  MusicApp
//
//  Created by Ravi Patel on 4/6/21.
//

import UIKit

class AlbumDetailViewController: UIViewController {

    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    var album: MusicAlbum?
    var networkClient: NetworkClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = album?.name
        networkClient = NetworkClient()
        populatData()
    }
    
    private func populatData(){
        fetchAlbumArtwork()
        if let album = album{
            albumNameLabel.text = album.name
            artistNameLabel.text = album.artistName
            
            if let genres = album.genres{
                var genreString: String = ""
                for genre in genres{
                    genreString += (genre.name ?? "") + " "
                }
                genreLabel.text = genreString
            }
            else{
                genreLabel.text = "N/A"
            }
        }
    }

    private func fetchAlbumArtwork(){
        if let artworkURL = album?.artworkUrl100{
            let url = URL(string: artworkURL)!
            networkClient.getAlbumArtwork(fromURL: url) { (image) in
                DispatchQueue.main.async {
                    if let image = image{
                        self.albumArtImageView.image = image
                    }
                }
            }
        }
        
    }
}
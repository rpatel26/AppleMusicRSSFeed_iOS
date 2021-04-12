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
    
    @IBAction func artistURLClicked(_ sender: Any) {
        guard let url_string = album?.artistUrl else {
            let alert = UIAlertController(title: "Error", message: "URL Does not exist.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        print("Artist URL: \(url_string)")
        let url = URL(string: url_string)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func musicURLClicked(_ sender: Any) {
        guard let url_string = album?.url else {
            let alert = UIAlertController(title: "Error", message: "URL Does not exist.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        print("Music URL: \(url_string)")
        let url = URL(string: url_string)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

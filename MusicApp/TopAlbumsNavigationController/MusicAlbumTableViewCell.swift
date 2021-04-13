//
//  MusicAlbumTableViewCell.swift
//  MusicApp
//
//  Created by Ravi Patel on 4/6/21.
//

import UIKit

class MusicAlbumTableViewCell: UITableViewCell {    
    var albumArt: UIImageView!
    var albumName: UILabel!
    var artistName: UILabel!
    var starButton: UIButton!
    var favoritesDelegate: FavoritedAlbum?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let width = self.contentView.frame.width
        let height = self.contentView.frame.height
                
        albumArt = UIImageView(frame: CGRect(x: width * 0.03, y: height * 0.05, width: 128, height: height * 0.9))
        
        let albumNameWidth = (width * 0.95) - (albumArt.frame.maxX + 10)
        albumName = UILabel(frame: CGRect(x: albumArt.frame.maxX + 10, y: albumArt.frame.minY, width: albumNameWidth, height: 25))
        albumName.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        albumName.lineBreakMode = .byWordWrapping
        albumName.numberOfLines = 0
        albumName.lineBreakStrategy = .pushOut
        
        artistName = UILabel(frame: CGRect(x: albumName.frame.minX, y: albumName.frame.maxY + 8, width: albumNameWidth, height: 25))
        artistName.font = UIFont(name: "HelveticaNeue", size: 18)
        artistName.textColor = .gray
        
        
        contentView.addSubview(albumArt)
        contentView.addSubview(albumName)
        contentView.addSubview(artistName)
        
        // Adding the favroites star button
        starButton = UIButton(type: .system)
        starButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        starButton.setImage(UIImage(named: "fav_star"), for: .normal)
        starButton.tintColor = .lightGray
        starButton.addTarget(self, action: #selector(favoritesButtonClicked), for: .touchUpInside)
        accessoryView = starButton
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc private func favoritesButtonClicked(button: UIButton){
        favoritesDelegate?.favoritesToggled(forCell: self)
    }

}

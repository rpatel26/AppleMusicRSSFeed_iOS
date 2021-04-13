//
//  Extensions.swift
//  MusicApp
//
//  Created by Ravi Patel on 4/6/21.
//

import UIKit

extension String{
    static let TOP_ALBUM_URL_STRINGS = [
        "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/10/explicit.json",
        "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/25/explicit.json",
        "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/50/explicit.json",
        "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json"
    ]
}

extension URL{
    static let TOP_ALBUM_URL = [
        URL(string: String.TOP_ALBUM_URL_STRINGS[0])!,
        URL(string: String.TOP_ALBUM_URL_STRINGS[1])!,
        URL(string: String.TOP_ALBUM_URL_STRINGS[2])!,
        URL(string: String.TOP_ALBUM_URL_STRINGS[3])!
    ]
}

extension NSNotification.Name {
    static let RELOAD_DATA = NSNotification.Name("Data_Ready_For_Reload")
    static let FAVORITES_ADDED = NSNotification.Name("Album added to favorites")
    static let FAVORITES_REMOVED = NSNotification.Name("Album removed from favorites")
}

extension UIColor{
    static let FAVORITES_COLOR = UIColor(red: 68/255, green: 121/255, blue: 251/255, alpha: 1)
}

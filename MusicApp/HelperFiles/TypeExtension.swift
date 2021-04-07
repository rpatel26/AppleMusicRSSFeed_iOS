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

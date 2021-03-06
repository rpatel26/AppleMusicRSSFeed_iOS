//
//  MusicStructs.swift
//  MusicApp
//
//  Created by Ravi Patel on 4/6/21.
//

class MusicAlbum: Decodable{
    let artistName: String?
    let id: String?
    let releaseDate: String?
    let name: String?
    let copyright: String?
    let contentAdvisoryRating: String?
    let artworkUrl100: String?
    let artistUrl: String?
    let genres: [MusicGenre]?
    let url: String?
    var uniqueId: Int?
    var isFavorited: Bool?
}

struct MusicGenre: Decodable {
    let genreId: String?
    let name: String?
    let url: String?
}

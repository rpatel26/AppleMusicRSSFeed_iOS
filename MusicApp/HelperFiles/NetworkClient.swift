//
//  NetworkClient.swift
//  MusicApp
//
//  Created by Ravi Patel on 4/6/21.
//

import UIKit

class NetworkClient{
    
    func getTopAlbum(withURL url: URL, onComplete: @escaping (_ musicAlbums: [MusicAlbum]) -> (), onError: @escaping (Error) -> ()){
        URLSession.shared.dataTask(with: url){(data,response,error) in
            if let err = error{
                print("Error fetching data: \(err.localizedDescription)")
                onError(err)
            }
            
            guard let data = data else { return }
            
            
            do{
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                guard let feed = json["feed"] as? [String: Any] else { return }
                
                let albums = try JSONDecoder().decode([MusicAlbum].self, from: JSONSerialization.data(withJSONObject: feed["results"]!, options: .prettyPrinted))
                onComplete(albums)
                
            } catch let jsonErr {
                print("JSON Error: \(jsonErr.localizedDescription)")
                onError(jsonErr)
            }
            
            
        }.resume()
    }
    
    func getAlbumArtwork(fromURL url: URL, onComplete: @escaping (_ image: UIImage?) -> ()){
        if let data = try? Data(contentsOf: url) {
            let image = UIImage(data: data)
            onComplete(image)
        }
        else{
            onComplete(nil)
        }
        
    }
}

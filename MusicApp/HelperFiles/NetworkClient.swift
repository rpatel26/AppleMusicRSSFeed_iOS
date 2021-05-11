//
//  NetworkClient.swift
//  MusicApp
//
//  Created by Ravi Patel on 4/6/21.
//

import UIKit


enum NetworkError: String, Error {
    case unableToComplete = "Unable to complete the request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server is invalid. Please try again"
}


class NetworkClient{
    
    func getTopAlbum(withURL url: URL, onComplete: @escaping (Result<[MusicAlbum], NetworkError>) -> ()){
        URLSession.shared.dataTask(with: url){(data,response,error) in
            if let err = error{
                print("Error fetching data: \(err.localizedDescription)")
                onComplete(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                onComplete(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                onComplete(.failure(.invalidData))
                return
            }
            
            do{
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                guard let feed = json["feed"] as? [String: Any] else { return }
                
                let albums = try JSONDecoder().decode([MusicAlbum].self, from: JSONSerialization.data(withJSONObject: feed["results"]!, options: .prettyPrinted))
               
                for (idx, _) in albums.enumerated(){
                    albums[idx].uniqueId = idx
                }
                
                onComplete(.success(albums))
                
            } catch let jsonErr {
                print("JSON Error: \(jsonErr.localizedDescription)")
                onComplete(.failure(.invalidData))
            }
            
            
        }.resume()
    }
    
    func getAlbumArtwork(fromURL url: URL, onComplete: @escaping (_ image: UIImage?) -> ()){
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                onComplete(image)
            }
            else{
                onComplete(nil)
            }
        }
    }
}

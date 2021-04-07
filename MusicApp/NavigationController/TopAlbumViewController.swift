//
//  TopAlbumViewController.swift
//  MusicApp
//
//  Created by Ravi Patel on 4/6/21.
//

import UIKit
import  DropDown

class TopAlbumViewController: UIViewController {

    @IBOutlet weak var topAlbumTableView: UITableView!
    @IBOutlet weak var fetchAmountButton: UIButton!
    @IBOutlet weak var sortingButton: UIButton!
    
    var fetchAmountList: DropDown!
    var sortingList: DropDown!
    private var fetchAmountIndex: Int!
    private var sortingCriteria: String!
    var activityIndicator: UIActivityIndicatorView!
    var networkClient: NetworkClient!
    var albums: [MusicAlbum] = [MusicAlbum]()
    var selectedAlbum: MusicAlbum?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAmountIndex = 1
        sortingCriteria = "Ratings"
        
        configureFetchingList()
        configureSortingList()
        configureTableView()

        networkClient = NetworkClient()
        
        activityIndicator.startAnimating()
        getTopMusicAlbum(withURL: URL.TOP_ALBUM_URL[1])
    }
    
    private func getTopMusicAlbum(withURL url: URL){
        
        networkClient.getTopAlbum(withURL: url) { (result) in
            switch result {
                case .success(let musicAlbums):
                    self.albums = musicAlbums
                    let group = DispatchGroup()
                    group.enter()
                    DispatchQueue.global().async {
                        self.sortAlbum(by: self.sortingCriteria)
                        group.leave()
                    }
                    
                    group.notify(queue: .global()) {
                        DispatchQueue.main.async {
                            self.topAlbumTableView.reloadData()
                            self.activityIndicator.stopAnimating()
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        let alert = UIAlertController(title: "Error", message: "\(error.rawValue)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
            }
        }
    }
    
    fileprivate func sortAlbum(by value: String){
        if value == "Artists"{
            self.albums.sort { (album1, album2) -> Bool in
                return (album1.artistName ?? "") < (album2.artistName ?? "")
            }
        }
        else if value == "Album"{
            self.albums.sort { (album1, album2) -> Bool in
                return (album1.name ?? "") < (album2.name ?? "")
            }
        }
    }
    
    private func configureSortingList() {
        sortingList = DropDown()
        sortingList.dataSource = ["Ratings", "Artists", "Album"]
        sortingList.anchorView = sortingButton
        sortingList.selectRow(0)
        sortingList.selectionAction = { (index, value) in
            self.sortingButton.setTitle(value, for: .normal)
            self.sortingCriteria = value
            
            if index != 0{
                self.activityIndicator.startAnimating()
                self.sortAlbum(by: value)
                DispatchQueue.main.async {
                    self.topAlbumTableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
            else{
                self.activityIndicator.startAnimating()
                self.getTopMusicAlbum(withURL: URL.TOP_ALBUM_URL[self.fetchAmountIndex])
            }
        }
    }
    
    private func configureFetchingList() {
        fetchAmountList = DropDown()
        fetchAmountList.dataSource = ["10 Albums", "25 Albums", "50 Albums", "100 Albums"]
        fetchAmountList.anchorView = fetchAmountButton
        fetchAmountList.selectRow(1)
        fetchAmountList.selectionAction = { (index, value) in
            self.fetchAmountIndex = index
            self.fetchAmountButton.setTitle(value, for: .normal)
            self.activityIndicator.startAnimating()
            self.getTopMusicAlbum(withURL: URL.TOP_ALBUM_URL[index])
        }
    }
    
    private func configureTableView() {
        topAlbumTableView.delegate = self
        topAlbumTableView.dataSource = self
        topAlbumTableView.refreshControl = UIRefreshControl()
        topAlbumTableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        activityIndicator.style = .large
        activityIndicator.color = .darkGray
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
    }
    
    @IBAction func fetchAmountButtonClicked(_ sender: Any) {
        fetchAmountList.show()
    }
    
    @IBAction func sortButtonClicked(_ sender: Any) {
        sortingList.show()
    }
    
    @objc func refreshData(){
        self.getTopMusicAlbum(withURL: URL.TOP_ALBUM_URL[fetchAmountIndex])
        topAlbumTableView.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AlbumDetailViewController
        destination.album = selectedAlbum
    }
}

extension TopAlbumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! MusicAlbumTableViewCell
        cell.artistName.text = albums[indexPath.row].artistName
        cell.albumName.text = albums[indexPath.row].name

        let artworkURL = URL(string: albums[indexPath.row].artworkUrl100 ?? "")!
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
        selectedAlbum = albums[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "albumDetail", sender: nil)
    }
    
    
}

//
//  WebKitViewController.swift
//  MusicApp
//
//  Created by Ravi Patel on 4/12/21.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController {

    @IBOutlet weak var webKitWebView: WKWebView!
    
    var url: URL?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = url{
            webKitWebView.load(URLRequest(url: url))
        }
        else{
            let alert = UIAlertController(title: "Error", message: "URL Does not exist.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
}

//
//  feedtipswebViewController.swift
//  poultry farm
//
//  Created by Apple on 19/06/24.
//

import UIKit
import WebKit

class feedtipswebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "https://grow.ifa.coop/chickens/what-to-feed-your-chickens-from-chicks-to-hens") {
                    let request = URLRequest(url: url)
                    webView.load(request)
                }
    }
    


}

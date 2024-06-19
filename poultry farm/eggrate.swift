//
//  eggrate.swift
//  poultry farm
//
//  Created by Apple on 19/06/24.
//

import UIKit
import WebKit

class eggrate: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "https://www.kisandeals.com/mandiprices/EGG/TELANGANA/ALL") {
                    let request = URLRequest(url: url)
                    webView.load(request)
                }
        // Do any additional setup after loading the view.
    }
    



}

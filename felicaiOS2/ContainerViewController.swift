import UIKit
import WebKit

class ContainerViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var wevBiew: WKWebView!
    var firstURL = "https://www.yahoo.co.jp"
    var sendURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openURL(urlString: firstURL)
        wevBiew.navigationDelegate = self
    }


    // 文字列で指定されたURLをWeb Viewを開く
    func openURL(urlString: String) {
        let url = URL(string: urlString)
        let request = NSURLRequest(url: url!)
        wevBiew.load(request as URLRequest)
    }
    
    
}

import UIKit
import WebKit

class ViewController: UIViewController {
    
    //初期化
    var gate1 = "str"
    private var webView: WKWebView!
    
    //ボタンの設定
    @IBOutlet var buttonWaseda: UIButton!
    @IBOutlet var buttonToyama: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var loginFinish: UIButton!
    
    
    //読み込み時に実行
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginFinish.isHidden = true
        webView = WKWebView(frame: CGRect(x:0, y:44, width:self.view.bounds.size.width, height:self.view.bounds.size.height - 119))
    }//override
    
    

    
    //ボタン押された
    @IBAction func Waseda(_ sender:Any){
        gate1 = "waseda"
        performSegue(withIdentifier: "toWaseda",sender: nil)
    }
    
    @IBAction func Toyama(_ sender:Any){
        gate1 = "toyama"
        performSegue(withIdentifier: "toToyama",sender: nil)
    }
    
    @IBAction func Login(_ sender:Any){
        let sentURL = "https://docs.google.com/document/d/16huuwNOUEYedL3L0Ig1YwP8e9mESXeoebFzlmjy9NQ0/edit?usp=sharing"
        let encordedURL = sentURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = NSURL(string: encordedURL!)
        let request = NSURLRequest(url: url! as URL)

        webView.load(request as URLRequest)
        self.view.addSubview(webView)
        
        loginFinish.isHidden = false
    }
    
    @IBAction func close(_ sender:Any){
        webView.isHidden = true
        loginFinish.isHidden = true
        loginButton.isHidden = true
    }
 
    //画面遷移の準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let read: readViewController = (segue.destination as? readViewController)!
            read.gate2 = gate1
    }
    
    

    
    
}//class


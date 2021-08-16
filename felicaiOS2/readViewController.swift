import UIKit
import CoreNFC
import WebKit

class readViewController: UIViewController, NFCTagReaderSessionDelegate, WKNavigationDelegate{
    
    @IBOutlet var label: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet weak var webView: WKWebView!
    var session: NFCTagReaderSession?
    var gate2: String = ""
    var sentURL: String = ""
    var str = "readNFCは動いてるよ"
    var firstURL = "https://dev.to/"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = gate2
        openURL(urlString: firstURL)
    }
    
    
    func openURL(urlString: String) {
            let url = URL(string: urlString)
            let request = NSURLRequest(url: url!)
            webView.load(request as URLRequest)
            webView.navigationDelegate = self
    }
   
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        startReading()
    }
    
    func startReading(){
        readNFC()
    }
    
    func readNFC(){
        self.session = NFCTagReaderSession(pollingOption: .iso18092, delegate: self)
        self.session?.begin()
        print(str)
    }
    

    
    //スキャン開始
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("読み取りを開始したツノ！")
    }

    
    //読み取り失敗
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError {
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                let alertController = UIAlertController(
                    title: "エラーが発生したツノ",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "わかったツノ...", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }

        self.session = nil
    }

    
    //読み取り成功
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print("カードが見つかったツノ！")

        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.milliseconds(200)
            session.alertMessage = "複数枚のカードが見つかったツノ。1枚で試してほしいツノ！"
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }

        let tag = tags.first!

        session.connect(to: tag) { (error) in
            if nil != error {
                session.invalidate(errorMessage: "接続エラーツノ。もう一回試してほしいツノ！")
                return
            }

            guard case .feliCa(let feliCaTag) = tag else {
                let retryInterval = DispatchTimeInterval.milliseconds(200)
                session.alertMessage = "このカードには対応していないツノ..."
                DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                    session.restartPolling()
                })
                return
            }


            let idmString0:String = feliCaTag.currentIDm.map { String(format: "%.2hhx", $0) }.joined()
            let idmString:String = idmString0.uppercased()
            print(idmString)

            session.alertMessage = idmString
            session.invalidate()
            
            self.sentURL = "https://script.google.com/a/wasedasai.net/macros/s/AKfycbw9BMWL3BLRhB8ZlIs32scTBWceP0TYy28wnWtBD2btOatmNiiw/exec?idm=" + idmString + "&&gate=" + self.gate2
            self.openURL(urlString: self.sentURL)
        }

        
        
    }//func
    

}//class
    


    




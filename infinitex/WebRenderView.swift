import SwiftUI
import WebKit

class WebView: NSObject, ObservableObject, WKNavigationDelegate {
    
    let webView = WKWebView()
    @Published var image:NSImage = NSImage(systemSymbolName: "infinity.circle.fill", accessibilityDescription: "image")!
    
    override init() {
        super.init()
        self.webView.navigationDelegate = self
        self.webView.frame = CGRect(x: 0, y: 0, width: 10000, height: 10000)
    }
    
    public func generate(htmlString: String) {
        webView.loadHTMLString(RenderObject(withContents: htmlString).html(), baseURL: URL(string: "http://test.com")!)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finished navigation")
        webView.evaluateJavaScript(RenderObject.evalCode) { res, error in
            let data = res as! [NSNumber]

            let width = Int(truncating: data[0])
            let height = Int(truncating: data[1])
            
            let snapshotConfig = WKSnapshotConfiguration()
            snapshotConfig.rect = CGRect(x: 0, y: 0, width: width, height: height)
            webView.takeSnapshot(with: snapshotConfig) { img, error in
                self.image = img!
            }
        }
    }
    
}


import Foundation

class RenderObject {
    
    public static let wPadding = 40;
    public static let hPadding = 20;
    
    private let script1 = "<script src=\"https://polyfill.io/v3/polyfill.min.js?features=es6\"></script>"
    private let script2 = """
    <script>
        window.MathJax = {
            tex: {
                inlineMath: [['$', '$'], ['\\(', '\\)']]
            },
            svg: {
                fontCache: 'global'
            }
        };

        (function () {
          var script = document.createElement('script');
          script.src = 'https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js';
          script.async = true;
          document.head.appendChild(script);
        })();
    </script>
    """
    
    private let js = """
    <script>
        document.onreadystatechange = function () {
             if (document.readyState == "complete") {
                console.log(MathJax)
                MathJax.typeset()
            }
        }
    </script>
    <style>
h1 {
    display: inline-block;
    height: auto;
    width: auto;
    margin: 0;
    padding: \(RenderObject.hPadding) \(RenderObject.wPadding);
}
body, html {
    margin: 0;
    padding:0;
}
    </style>
"""
    
    private let api = """
        <script>
            func getWidth() {
                return document.getElementById('h1').getBoundingClientRect().width
            }
        </script>
"""
    
    public static let evalCode = """
        const width = document.getElementsByTagName('h1')[0].getBoundingClientRect().width;
        const height = document.getElementsByTagName('h1')[0].getBoundingClientRect().height;
        [width, height]
"""
    
    private var _latexConversion: String
    
    init(withContents contents: String) {
        _latexConversion = contents
    }
    
    public func html() -> String {
        return script1 + script2 + "<h1>$\(_latexConversion)$</h1>" + js
    }
    
}

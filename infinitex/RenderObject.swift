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
    font-size: 200px;
    padding: \(RenderObject.hPadding) \(RenderObject.wPadding);
}
body, html {
    margin: 0;
    padding:0;
}
    </style>
"""
    
    private let whiteMode = """
        body, html {
            background-color: #ffffff;
        }
        svg, path, fill {
            color: black;
        }
    """
    
    private let lightMode = """
        body, html {
            background-color: #eeeeee;
        }
        svg, path, fill {
            color: black;
        }
    """
    
    private let darkMode = """
        body, html {
            background-color: #232323 !important;
        }
        svg, path, fill {
            color: white;
        }
    """
    
    private let blackMode = """
        body, html {
            background-color: #000000 !important;
        }
        svg, path, fill {
            color: white;
        }
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
    
    public func html(colorMode: Int = 0) -> String {
        var h = script1 + script2 + "<h1>$\(_latexConversion)$</h1>" + js
        if colorMode == 0 { h += lightDarkAutoMode() }
        else if colorMode == 1 { h += whiteBlackAutoMode() }
        else if colorMode == 2 { h += modeStatic(mode: whiteMode) }
        else if colorMode == 3 { h += modeStatic(mode: lightMode) }
        else if colorMode == 4 { h += modeStatic(mode: darkMode) }
        else if colorMode == 5 { h += modeStatic(mode: blackMode) }
        return h
    }

    private func modeStatic(mode: String) -> String {
        return """
        <style>
            \(mode)
        </style>
        """
    }
    
    private func darkModeStatic() -> String {
        return """
        <style>
            \(darkMode)
        </style>
        """
    }
    private func lightDarkAutoMode() -> String {
        return """
        <style>
        \(lightMode)
        @media (prefers-color-scheme: dark) {
            \(darkMode)
        }
        </style>
        """
    }
    private func whiteBlackAutoMode() -> String {
        return """
        <style>
        \(whiteMode)
        @media (prefers-color-scheme: dark) {
            \(blackMode)
        }
        </style>
        """
    }
}

class RefreshInterval {
    static func forPerformanceMode(mode: Int) -> DispatchTime {
        if mode == 1 {
            return .now() + 1
        } else if mode == 2 {
            return .now() + 0.2
        } else if mode == 3 {
            return .now() + 0.01
        } else {
            return .now()
        }
    }
}

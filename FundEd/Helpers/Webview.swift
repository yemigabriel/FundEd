//
//  WebView.swift
//  FundEd
//
//  Created by Yemi Gabriel on 2/28/22.
//

import Foundation
import SwiftUI
import WebKit

struct Webview: UIViewRepresentable {
    @Binding var showLoading: Bool
    @Binding var isPaymentSuccessful: Bool
    @Binding var shouldDismiss: Bool
    let url: String
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        
        var parent: Webview
        var didStart: () -> Void
        var didFinish: () -> Void
        
        init(_ parent: Webview, didStart: @escaping ()->Void = {}, didFinish: @escaping ()->Void = {}) {
            self.parent = parent
            self.didStart = didStart
            self.didFinish = didFinish
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            didStart()
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print(error)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            didFinish()
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "pystkCallbackHandler" {
                print("payment successfull")
                parent.isPaymentSuccessful = true
                parent.shouldDismiss = true
            }
        }
        
    }
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.url) else {
            return WKWebView()
        }
        
        let request = URLRequest(url: url)
        
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController();
        
        contentController.add(context.coordinator, name: "pystkCallbackHandler")
        config.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self) {
            self.showLoading = true
        } didFinish: {
            self.showLoading = false
        }

    }
}

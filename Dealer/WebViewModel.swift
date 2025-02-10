//
//  WebViewModel.swift
//  Dealer
//
//  Created by 秋星桥 on 2/9/25.
//

import Combine
import SwiftUI
import WebKit

@dynamicMemberLookup
class WebViewModel: NSObject, ObservableObject, WKNavigationDelegate, WKUIDelegate {
    let webView: WKWebView
    var observers: [NSKeyValueObservation] = []

    override init() {
        let config = WKWebViewConfiguration()
        config.allowsAirPlayForMediaPlayback = false
        config.mediaTypesRequiringUserActionForPlayback = .all
        webView = WKWebView(frame: .zero, configuration: config)
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1"

        super.init()

        webView.uiDelegate = self
        webView.navigationDelegate = self
        observers = [
            subscriber(for: \.title),
            subscriber(for: \.url),
            subscriber(for: \.isLoading),
            subscriber(for: \.estimatedProgress),
            subscriber(for: \.hasOnlySecureContent),
            subscriber(for: \.serverTrust),
            subscriber(for: \.canGoBack),
            subscriber(for: \.canGoForward),
            subscriber(for: \.themeColor),
            subscriber(for: \.underPageBackgroundColor),
            subscriber(for: \.microphoneCaptureState),
            subscriber(for: \.cameraCaptureState),
        ]
    }

    func subscriber(for keyPath: KeyPath<WKWebView, some Any>) -> NSKeyValueObservation {
        webView.observe(keyPath, options: [.prior]) { [weak self] _, change in
            guard let self else { return }
            if change.isPrior { objectWillChange.send() }
        }
    }

    subscript<T>(dynamicMember keyPath: KeyPath<WKWebView, T>) -> T {
        webView[keyPath: keyPath]
    }

    var nextCompletion: ((WKWebView) -> Void)?

    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        nextCompletion?(webView)
        nextCompletion = nil
    }
}

#if canImport(AppKit)

    struct WebView: View, NSViewRepresentable {
        let svm: WebViewModel

        init(svm: WebViewModel) {
            self.svm = svm
        }

        func makeNSView(context _: NSViewRepresentableContext<WebView>) -> NSView {
            svm.webView
        }

        func updateNSView(_: NSView, context _: Context) {}
    }
#else

    #if canImport(UIKit)
        struct WebView: View, UIViewRepresentable {
            let svm: WebViewModel

            init(svm: WebViewModel) {
                self.svm = svm
            }

            func makeUIView(context _: Context) -> UIView {
                svm.webView
            }

            func updateUIView(_: UIView, context _: Context) {}
        }
    #endif

#endif

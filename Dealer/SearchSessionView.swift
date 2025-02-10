//
//  SearchSessionView.swift
//  Dealer
//
//  Created by 秋星桥 on 2/9/25.
//

import SwiftUI

struct SearchSessionView: View {
    let keyword: String
    let engine: SearchEngine

    @StateObject var wvs = WebViewModel()
    @State var error: String = ""
    @State var link: String = ""

    @Binding var isExpended: Bool

    @State var showExpendButton: Bool = false
    @State var loadComplete: Bool = false
    @State var estProgressFraction: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if loadComplete {
                    WebView(svm: wvs)
                        .transition(.opacity.combined(with: .scale(scale: 0.975)))
                    if !isExpended { expendButton }
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.opacity.combined(with: .scale(scale: 0.975)))
                }
            }
            .animation(.spring, value: loadComplete)
            .onAppear {
                guard let request = engine.makeSearchQueryRequest(keyword) else {
                    error = String(localized: "Failed to create search request.")
                    return
                }
                link = request.url?.absoluteString ?? String(localized: "Unknown")
                estProgressFraction = 0
                wvs.nextCompletion = { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        loadComplete = true
                    }
                }
                wvs.webView.load(request)
            }
            Divider()
            Button {
                if isExpended {
                    isExpended = false
                } else {
                    guard let url = wvs.webView.url else { return }
                    #if canImport(AppKit)
                        NSWorkspace.shared.open(url)
                    #else
                        #if canImport(UIKit)
                            UIApplication.shared.open(url)
                        #endif
                    #endif
                }
            } label: {
                HStack(spacing: 16) {
                    if !isExpended {
                        Text(link)
                            .underline()
                            .lineLimit(1)
                        Spacer()
                    }
                    Image(systemName: !isExpended ? "arrow.up.right.circle.fill" : "arrow.down.right.and.arrow.up.left")
                }
                .font(.footnote)
                .frame(maxWidth: .infinity)
                .padding(8)
            }
            .buttonStyle(.plain)
            .background(
                GeometryReader { r in
                    Rectangle()
                        .foregroundStyle(.accent.opacity(0.1))
                        .frame(width: r.size.width * estProgressFraction)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                }
                .animation(.linear, value: estProgressFraction)
            )
        }
        .overlay {
            if !error.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                    Text(error)
                        .underline()
                }
                .bold()
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .background(.thickMaterial)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
        .cornerRadius(6)
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 0)
        .onChange(of: wvs.webView.estimatedProgress) { newValue in
            estProgressFraction = newValue
        }
        .onChange(of: wvs.webView.url) { newValue in
            if let url = newValue { link = url.absoluteString }
        }
    }

    var expendButton: some View {
        Button { isExpended = true } label: {
            Rectangle()
                .foregroundStyle(.clear)
                .disabled(!isExpended)
                .overlay {
                    VStack(spacing: 16) {
                        Image(systemName: "arrow.down.left.and.arrow.up.right")
                            .font(.largeTitle)
                        Text("Click to Expend")
                            .underline()
                    }
                    .foregroundStyle(.white)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .background(.black.opacity(0.75))
                    .opacity(showExpendButton ? 1 : 0)
                    .animation(.spring, value: showExpendButton)
                }
                .onHover { isHover in
                    if !isExpended { showExpendButton = isHover }
                }
        }
        .buttonStyle(.plain)
        .onDisappear { showExpendButton = false }
    }
}

#Preview {
    SearchSessionView(keyword: "你好", engine: .google, isExpended: .constant(false))
        .frame(width: 300, height: 600)
}

//
//  main.swift
//  Dealer
//
//  Created by 秋星桥 on 2/9/25.
//

import SwiftUI

URLSession.shared.dataTask(
    with: .init(string: "https://captive.apple.com")!
).resume()

DealerApp.main()

struct DealerApp: App {
    var body: some Scene {
        #if os(macOS)

            WindowGroup {
                SearchView()
                    .frame(minWidth: 800, minHeight: 500)

//                VStack(spacing: 0) {
//                    AvatarView()
//                        .frame(width: 512, height: 512)
//                        .clipped()
//                    Divider()
//                    Button("Save") {
//                        let view = AvatarView()
//                            .frame(width: 512, height: 512)
//                        let renderer = ImageRenderer(content: view)
//                        renderer.scale = 2
//                        guard let image = renderer.nsImage else { return }
//                        let panel = NSOpenPanel()
//                        panel.canChooseFiles = false
//                        panel.canChooseDirectories = true
//                        panel.allowsMultipleSelection = false
//                        panel.begin { result in
//                            if result == .OK, let url = panel.url {
//                                let path = url.appendingPathComponent("Dealer Avatar.png")
//                                do {
//                                    try image.tiffRepresentation?.write(to: path)
//                                } catch {
//                                    print(error)
//                                }
//                            }
//                        }
//                    }
//                    .padding()
//                }
//                .fixedSize()
            }
            .windowStyle(.hiddenTitleBar)
            .windowResizability(.contentSize)
        #else
            WindowGroup {
                SearchView()
            }
        #endif
    }
}

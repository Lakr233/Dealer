//
//  SearchEngine.swift
//  Dealer
//
//  Created by 秋星桥 on 2/9/25.
//

import Foundation

enum SearchEngine: String, CaseIterable, Codable {
    case google
    case duckduckgo
    case yahoo
    case yandex
    case bing

    case appleMusic
    case soundcloud

    case youtube
    case bilibili
    case vimeo

    case googleImage
    case pinterest
    case pixiv

    var template: String {
        switch self {
        case .google:
            "https://www.google.com/search?q=%@"
        case .bing:
            "https://www.bing.com/search?q=%@"
        case .duckduckgo:
            "https://www.duckduckgo.com/?q=%@"
        case .yahoo:
            "https://search.yahoo.com/search?q=%@"
        case .yandex:
            "https://yandex.ru/yandsearch?text=%@"
        case .appleMusic:
            "https://music.apple.com/search?term=%@"
        case .soundcloud:
            "https://soundcloud.com/search?q=%@"
        case .youtube:
            "https://www.youtube.com/results?search_query=%@"
        case .bilibili:
            "https://search.bilibili.com/all?keyword=%@"
        case .vimeo:
            "https://vimeo.com/search?q=%@"
        case .googleImage:
            "https://www.google.com/search?udm=2&q=%@"
        case .pinterest:
            "https://www.pinterest.com/search/pins/?q=%@"
        case .pixiv:
            "https://www.pixiv.net/tags/%@"
        }
    }

    func makeSearchQueryRequest(_ keyword: String) -> URLRequest? {
        let encoder = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let text = String(format: template, encoder ?? "")
        guard let url = URL(string: text) else {
            return nil
        }
        return URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 60
        )
    }

    var name: String {
        switch self {
        case .google:
            String(localized: "Google")
        case .bing:
            String(localized: "Bing")
        case .duckduckgo:
            String(localized: "DuckDuckGo")
        case .yahoo:
            String(localized: "Yahoo")
        case .yandex:
            String(localized: "Yandex")
        case .appleMusic:
            String(localized: "Apple Music")
        case .soundcloud:
            String(localized: "SoundCloud")
        case .youtube:
            String(localized: "YouTube")
        case .bilibili:
            String(localized: "Bilibili")
        case .vimeo:
            String(localized: "Vimeo")
        case .googleImage:
            String(localized: "Google Image")
        case .pinterest:
            String(localized: "Pinterest")
        case .pixiv:
            String(localized: "Pixiv")
        }
    }

    enum EngineType: String, CaseIterable, Codable {
        case web
        case music
        case video
        case image

        var name: String {
            switch self {
            case .web:
                String(localized: "Web")
            case .music:
                String(localized: "Music")
            case .video:
                String(localized: "Video")
            case .image:
                String(localized: "Image")
            }
        }
    }

    var engineType: EngineType {
        switch self {
        case .google, .bing, .duckduckgo, .yahoo, .yandex:
            .web

        case .appleMusic, .soundcloud:
            .music

        case .youtube, .bilibili, .vimeo:
            .video

        case .googleImage, .pinterest, .pixiv:
            .image
        }
    }
}

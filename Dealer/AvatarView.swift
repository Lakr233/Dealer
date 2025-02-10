//
//  AvatarView.swift
//  Dealer
//
//  Created by 秋星桥 on 2/10/25.
//

import ColorfulX
import SwiftUI

struct AvatarView: View {
    var body: some View {
        ZStack {
            Spacer().frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack(spacing: 8) {
                ForEach(0 ..< 32, id: \.self) { _ in
                    HStack(spacing: 8) {
                        ForEach(0 ..< 32, id: \.self) { _ in
                            Image(systemName: "text.page.badge.magnifyingglass")
                                .font(.system(size: 32, weight: .regular, design: .rounded))
                        }
                    }
                }
            }
            .opacity(0.05)
            .fixedSize()
            .rotationEffect(.degrees(-15))
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.accent)
                .font(.system(size: 128, weight: .regular, design: .rounded))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 0)
        }
        .background(.background)
    }
}

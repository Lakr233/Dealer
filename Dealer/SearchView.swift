//
//  SearchView.swift
//  Dealer
//
//  Created by 秋星桥 on 2/9/25.
//

import ColorfulX
import SwiftUI
import TipKit

struct SearchView: View {
    @StateObject var vm: ViewModel = .init()

    var backgroundColor: [ColorElement] {
        switch vm.status {
        case .editing:
            .init(repeating: .clear, count: 8)
        case .searching:
            ColorfulPreset.winter.colors
        }
    }

    var version: LocalizedStringKey {
        "Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1") Build: \(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")"
    }

    var body: some View {
        ZStack {
            if vm.status == .editing {
                editorContent
                    .padding()
            }
            VStack(spacing: 12) {
                cardsTitle.padding(12)
                cardsContent
            }
            .padding(8)
            .opacity(vm.status == .searching ? 1 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.spring, value: vm.status)
        .animation(.spring, value: vm.searchTitle)
        .background(
            ColorfulView(
                color: backgroundColor.map { .init($0) },
                speed: vm.status == .editing ? .constant(0) : .constant(0.5),
                noise: .constant(64),
                transitionSpeed: .constant(10),
                frameLimit: .constant(30),
                renderScale: .constant(1)
            )
            .opacity(0.25)
            .ignoresSafeArea()
        )
    }

    var editorContent: some View {
        VStack(spacing: 32) {
            Text("Dealer Search")
                .font(.system(.title, design: .rounded, weight: .semibold))
            SearchBar(vm: vm)
            Text(version)
                .font(.system(.footnote, design: .rounded, weight: .regular))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: 500)
        .transition(.opacity.combined(with: .scale(scale: 0.975)))
    }

    var cardsTitle: some View {
        HStack {
            Text(vm.searchTitle)
                .lineLimit(1)
                .contentTransition(.numericText())
                .underline(color: .accent.opacity(0.1))
                .contentShape(Rectangle())
                .onTapGesture {
                    vm.reset(keepText: true)
                }
            Spacer()
            Button {
                vm.reset(keepText: true)
            } label: {
                Image(systemName: "xmark")
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .keyboardShortcut(.cancelAction)
        }
        .font(.system(.title2, design: .rounded, weight: .bold))
    }

    var columnFactor: CGFloat {
        if vm.estimatedSearchSessions > 3 {
            return 3.2
        }
        if vm.estimatedSearchSessions > 2 {
            return .init(vm.estimatedSearchSessions) + 0.2
        }
        return .init(vm.estimatedSearchSessions)
    }

    func columnCollapsedWidth(_ width: CGFloat) -> CGFloat {
        let ret = width / columnFactor
        if ret < 300 { return width }
        return ret
    }

    var cardsContent: some View {
        GeometryReader { r in
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(vm.searchSessions) { session in
                            SearchSessionView(
                                keyword: vm.text,
                                engine: session.engine,
                                isExpended: .init(get: {
                                    vm.expendedIndex == session.index
                                }, set: { value in
                                    if value {
                                        vm.expendedIndex = session.index
                                    } else {
                                        if vm.expendedIndex == session.index {
                                            vm.expendedIndex = -1
                                        }
                                    }
                                    withAnimation(.spring) { proxy.scrollTo(session.index, anchor: .center) }
                                })
                            )
                            .frame(width: vm.expendedIndex == session.index ? min(r.size.width, 750) : columnCollapsedWidth(r.size.width))
                            .transition(.opacity.combined(with: .scale(scale: 0.975)))
                            .id(session.index)
                        }
                    }
                    .padding(20)
                }
                .scrollIndicators(.never)
                .padding(-20)
                .frame(maxHeight: .infinity)
            }
        }
        .animation(.spring, value: vm.searchSessions)
        .animation(.spring, value: vm.expendedIndex)
    }
}

#Preview {
    let vm = ViewModel()
    vm.text = "周杰伦什么时候出生？"
    vm.submit()
    return SearchView(vm: vm)
        .frame(width: 600, height: 300, alignment: .center)
}

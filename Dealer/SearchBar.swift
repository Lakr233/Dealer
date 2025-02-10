//
//  SearchBar.swift
//  Dealer
//
//  Created by 秋星桥 on 2/9/25.
//

import Pow
import SwiftUI

struct SearchBar: View {
    @StateObject var vm: ViewModel
    @FocusState var isFocused: Bool

    @State var failureAttempt: Int = 0

    var canSearch: Bool {
        !vm.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            Group {
                inputField
                typeField
            }
            .onKeyPress(.rightArrow) {
                vm.nextSearchType()
                return .handled
            }
            .onKeyPress(.leftArrow) {
                vm.previousSearchType()
                return .handled
            }
        } else {
            Group {
                inputField
                typeField
            }
        }
    }

    @ViewBuilder
    var inputField: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $vm.text, prompt: Text("Search with Dealer..."))
                .textFieldStyle(.plain)
                .focused($isFocused)
                .onSubmit {
                    guard canSearch else {
                        failureAttempt += 1
                        return
                    }
                    vm.submit()
                }
                .onAppear { isFocused = true }
            Image(systemName: "return")
                .foregroundColor(canSearch ? .accentColor : .secondary)
                .opacity(canSearch ? 1 : 0.25)
                .font(.footnote)
                .contentShape(Rectangle())
                .onTapGesture {
                    guard canSearch else {
                        failureAttempt += 1
                        return
                    }
                    vm.submit()
                }
        }
        .font(.system(.body, design: .rounded, weight: .semibold))
        .padding(8)
        .background(.background)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 0)
        .changeEffect(.shake(rate: .fast), value: failureAttempt)
    }

    @ViewBuilder
    var typeField: some View {
        HStack(spacing: 8) {
            ForEach(SearchEngine.EngineType.allCases, id: \.self) { type in
                Button {
                    vm.searchType = type
                } label: {
                    Text(type.name)
                        .foregroundStyle(type == vm.searchType ? .accent : .primary)
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .padding(4)
                        .padding(.horizontal, 4)
                        .background(type == vm.searchType ? .accent.opacity(0.25) : .white.opacity(0.5))
                        .cornerRadius(4)
                }
                .buttonStyle(.plain)
                .animation(.spring, value: vm.searchType)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 0)
            }
        }
    }
}

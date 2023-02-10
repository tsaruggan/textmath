//
//  TMEmojiKeyboard.swift
//  textmathkeyboard
//
//  Created by Saruggan Thiruchelvan on 2023-01-22.
//

import SwiftUI
import KeyboardKit

public struct TMEmojiCategoryKeyboard: View {
    
    public init(
        keyboardContext: KeyboardContext
    ) {
        self.categories = TMEmojiCategory.all.filter { $0.emojis.count > 0 }
        self.keyboardContext = keyboardContext
        self.appearance = TMKeyboardAppearance(keyboardContext: keyboardContext)
        self.initialSelection = nil
        //        self.style = .standardPhonePortrait
        self.style = .custom(for: keyboardContext)
    }
    
    private let categories: [TMEmojiCategory]
    private let keyboardContext: KeyboardContext
    private let appearance: KeyboardAppearance
    private let initialSelection: TMEmojiCategory?
    private let style: EmojiKeyboardStyle
    
    @State
    private var isInitialized = false
    
    @State
    private var isSearchFocused = false
    
    @State
    private var query = ""
    
    @State
    private var selection = TMEmojiCategory.greek
    
    private var defaults: UserDefaults { .standard }
    
    private let defaultsKey = "com.keyboardkit.TMEmojiKeyboard.category"
    
    private var persistedCategory: TMEmojiCategory {
        let name = defaults.string(forKey: defaultsKey) ?? ""
        return categories.first { $0.rawValue == name } ?? .greek
    }
    
    private func initialize() {
        if isInitialized { return }
        selection = initialSelection ?? persistedCategory
        isInitialized = true
    }
    
    private func saveCurrentCategory() {
        guard isInitialized else { return }
        defaults.set(selection.rawValue, forKey: defaultsKey)
    }
    
    
    public var body: some View {
        VStack(spacing: style.verticalCategoryStackSpacing) {
            title
            keyboard
            menu
        }
        .onAppear(perform: initialize)
        .onChange(of: selection) { _ in saveCurrentCategory() }
    }
}

private extension TMEmojiCategoryKeyboard {
    
    var title: some View {
        HStack {
            Text(selection.title)
                .bold()
                .textCase(.uppercase)
                .opacity(0.4)
            Spacer()
        }
        .padding(.horizontal)
    }
    
    var keyboard: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            TMEmojiKeyboard(
                emojis: selection.emojis.matching(query, for: keyboardContext.locale),
                style: style)
        }.id(selection)
    }
    
    var menu: some View {
        TMEmojiCategoryKeyboardMenu(
            categories: categories,
            appearance: appearance,
            keyboardContext: keyboardContext,
            selection: $selection,
            style: style
        )
    }
}

public extension EmojiKeyboardStyle {
    static func custom(
        for context: KeyboardContext
    ) -> EmojiKeyboardStyle {
        let style = EmojiKeyboardStyle(
            rows: 4,
            itemSize: 50,
            itemFont:.system(size: 30),
            horizontalItemSpacing:  16,
            verticalItemSpacing:  6,
            verticalCategoryStackSpacing:  0,
            categoryFont:  .system(size: 20),
            systemFont:  .system(size: 16),
            selectedCategoryColor:  .primary.opacity(0.1),
            abcText: "ABC",
            backspaceIcon:  .keyboardBackspace
        )
        return style
    }
}

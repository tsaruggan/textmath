//
//  TMKeyboardLayoutProvider.swift
//  textmathkeyboard
//
//  Created by Saruggan Thiruchelvan on 2023-02-13.
//

import Foundation
import KeyboardKit

class TMKeyboardLayoutProvider: StandardKeyboardLayoutProvider {
    
    override func keyboardLayout(for context: KeyboardContext) -> KeyboardLayout {
        if context.needsInputModeSwitchKey {
            // add emoji button for smaller iPhones
            let layout = super.keyboardLayout(for: context)
            var rows = layout.itemRows
            var row = layout.itemRows[rows.endIndex - 1]
            let next = row[0]
            let size = KeyboardLayoutItemSize(width: .input, height: next.size.height)
            let emojiButton = KeyboardLayoutItem(action: .keyboardType(.emojis), size: size, insets: next.insets)
            row.insert(emojiButton, at: 1)
            rows[rows.endIndex - 1] = row
            layout.itemRows = rows
            return layout
        } else {
            return super.keyboardLayout(for: context)
        }
    }
}

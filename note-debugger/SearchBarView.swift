//
//  SearchBarView.swift
//  note-debugger
//
//  Created by Jonathan Duran on 06/08/2025.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ColorPalette.accent)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(ColorPalette.accent)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(ColorPalette.light.opacity(0.2))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(ColorPalette.light.opacity(0.5), lineWidth: 1)
        )
    }
}

#Preview {
    SearchBarView(text: .constant(""), placeholder: "Buscar notas...")
        .padding()
}

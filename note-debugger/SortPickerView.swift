//
//  SortPickerView.swift
//  note-debugger
//
//  Created by Jonathan Duran on 06/08/2025.
//

import SwiftUI

struct SortPickerView: View {
    @Binding var selectedOption: NotesViewModel.SortOption
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.up.arrow.down")
                .foregroundColor(ColorPalette.secondary)
            
            Text("Ordenar por:")
                .font(.subheadline)
                .foregroundColor(ColorPalette.primary)
            
            Picker("Ordenar", selection: $selectedOption) {
                ForEach(NotesViewModel.SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .accentColor(ColorPalette.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(ColorPalette.light.opacity(0.2))
        )
    }
}

#Preview {
    SortPickerView(selectedOption: .constant(.dateCreated))
        .padding()
}

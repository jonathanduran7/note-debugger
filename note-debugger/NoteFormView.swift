//
//  NoteFormView.swift
//  note-debugger
//
//  Created by Jonathan Duran on 06/08/2025.
//

import SwiftUI

struct NoteFormView: View {
    @Binding var title: String
    let isEditing: Bool
    let onSave: () -> Void
    let onCancel: () -> Void
    
    @FocusState private var isTitleFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Título de la nota")
                        .font(.headline)
                        .foregroundColor(ColorPalette.primary)
                    
                    TextField("Ingresa el título de la nota", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isTitleFocused)
                        .padding(.horizontal, 4)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(isEditing ? "Editar Nota" : "Nueva Nota")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        onCancel()
                    }
                    .foregroundColor(ColorPalette.secondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        onSave()
                    }
                    .foregroundColor(ColorPalette.primary)
                    .fontWeight(.semibold)
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onAppear {
            isTitleFocused = true
        }
    }
}

#Preview {
    NoteFormView(
        title: .constant(""),
        isEditing: false,
        onSave: {},
        onCancel: {}
    )
}

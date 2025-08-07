//
//  NoteCardView.swift
//  note-debugger
//
//  Created by Jonathan Duran on 06/08/2025.
//

import SwiftUI

struct NoteCardView: View {
    let note: Note
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSxxx"
        
        if let date = formatter.date(from: note.created_at) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        
        return note.created_at
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(note.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(ColorPalette.primary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            
            HStack {
                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .foregroundColor(ColorPalette.secondary)
                    }
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: ColorPalette.light.opacity(0.3), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorPalette.light.opacity(0.5), lineWidth: 1)
        )
    }
}

#Preview {
    NoteCardView(
        note: Note(id: "test-id", created_at: "2025-08-07T00:50:02.832635+00:00", title: "Nota de ejemplo"),
        onEdit: {},
        onDelete: {}
    )
    .padding()
}

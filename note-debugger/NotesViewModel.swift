//
//  NotesViewModel.swift
//  note-debugger
//
//  Created by Jonathan Duran on 06/08/2025.
//

import Foundation
import SwiftUI

@MainActor
class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var searchText = ""
    @Published var showingAddNote = false
    @Published var showingEditNote = false
    @Published var selectedNote: Note?
    @Published var sortOption: SortOption = .dateCreated
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    
    enum SortOption: String, CaseIterable {
        case dateCreated = "Fecha de creación"
        case title = "Título"
    }
    
    var filteredNotes: [Note] {
        let filtered = searchText.isEmpty ? notes : notes.filter { note in
            note.title.localizedCaseInsensitiveContains(searchText)
        }
        
        return filtered.sorted { first, second in
            switch sortOption {
            case .dateCreated:
                return first.created_at > second.created_at
            case .title:
                return first.title.localizedCaseInsensitiveCompare(second.title) == .orderedAscending
            }
        }
    }
    
    func loadNotes() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedNotes = try await apiService.fetchNotes()
                notes = fetchedNotes
                isLoading = false
            } catch let apiError as APIError {
                errorMessage = apiError.errorDescription
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func addNote(title: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let newNote = try await apiService.createNote(title: title)
                notes.append(newNote)
                showingAddNote = false
                isLoading = false
            } catch let apiError as APIError {
                errorMessage = apiError.errorDescription
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func updateNote(_ note: Note, title: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let updatedNote = try await apiService.updateNote(id: note.id, title: title)
                if let index = notes.firstIndex(where: { $0.id == note.id }) {
                    notes[index] = updatedNote
                }
                showingEditNote = false
                selectedNote = nil
                isLoading = false
            } catch let apiError as APIError {
                errorMessage = apiError.errorDescription
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func deleteNote(_ note: Note) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await apiService.deleteNote(id: note.id)
                notes.removeAll { $0.id == note.id }
                isLoading = false
            } catch let apiError as APIError {
                errorMessage = apiError.errorDescription
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func selectNoteForEdit(_ note: Note) {
        selectedNote = note
        showingEditNote = true
    }
    
    func clearError() {
        errorMessage = nil
    }
}

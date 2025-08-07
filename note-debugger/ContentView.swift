//
//  ContentView.swift
//  note-debugger
//
//  Created by Jonathan Duran on 06/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NotesViewModel()
    
    @State private var showingDeleteAlert = false
    @State private var noteToDelete: Note?
    @State private var newNoteTitle = ""
    @State private var editNoteTitle = ""
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    SearchBarView(text: $viewModel.searchText, placeholder: "Buscar notas...")
                    
                    HStack {
                        SortPickerView(selectedOption: $viewModel.sortOption)
                        Spacer()
                    }
                }
                .padding()
                .background(ColorPalette.light.opacity(0.1))
                
                if viewModel.isLoading && !isRefreshing {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.2)
                            .foregroundColor(ColorPalette.primary)
                        
                        Text("Cargando notas...")
                            .font(.body)
                            .foregroundColor(ColorPalette.primary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                } else if viewModel.filteredNotes.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "note.text")
                            .font(.system(size: 60))
                            .foregroundColor(ColorPalette.accent)
                        
                        Text(viewModel.searchText.isEmpty ? "No hay notas" : "No se encontraron notas")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(ColorPalette.primary)
                        
                        if viewModel.searchText.isEmpty {
                            Text("Toca el botón + para crear tu primera nota")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                } else {
                    ZStack {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.filteredNotes, id: \.id) { note in
                                    NoteCardView(
                                        note: note,
                                        onEdit: {
                                            editNoteTitle = note.title
                                            viewModel.selectNoteForEdit(note)
                                        },
                                        onDelete: {
                                            noteToDelete = note
                                            showingDeleteAlert = true
                                        }
                                    )
                                }
                            }
                            .padding()
                        }
                        .background(Color.white)
                    }
                }
            }
            .navigationTitle("Mis Notas")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        refreshNotes()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(viewModel.isLoading ? ColorPalette.accent : ColorPalette.primary)
                            .font(.title2)
                            .rotationEffect(.degrees(isRefreshing ? 360 : 0))
                            .animation(isRefreshing ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isRefreshing)
                    }
                    .disabled(viewModel.isLoading)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        newNoteTitle = ""
                        viewModel.showingAddNote = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(ColorPalette.primary)
                            .font(.title2)
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showingAddNote) {
            NoteFormView(
                title: $newNoteTitle,
                isEditing: false,
                onSave: {
                    viewModel.addNote(title: newNoteTitle)
                },
                onCancel: {
                    viewModel.showingAddNote = false
                }
            )
        }
        .sheet(isPresented: $viewModel.showingEditNote) {
            NoteFormView(
                title: $editNoteTitle,
                isEditing: true,
                onSave: {
                    if let selectedNote = viewModel.selectedNote {
                        viewModel.updateNote(selectedNote, title: editNoteTitle)
                    }
                },
                onCancel: {
                    viewModel.showingEditNote = false
                    viewModel.selectedNote = nil
                }
            )
        }
        .alert("Eliminar Nota", isPresented: $showingDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Eliminar", role: .destructive) {
                if let note = noteToDelete {
                    viewModel.deleteNote(note)
                }
            }
        } message: {
            Text("¿Estás seguro de que quieres eliminar esta nota? Esta acción no se puede deshacer.")
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
        .onAppear {
            viewModel.loadNotes()
        }
        .refreshable {
            refreshNotes()
        }
    }
    
    private func refreshNotes() {
        isRefreshing = true
        viewModel.loadNotes()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isRefreshing = false
        }
    }
}

#Preview {
    ContentView()
}

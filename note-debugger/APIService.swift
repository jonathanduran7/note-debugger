//
//  APIService.swift
//  note-debugger
//
//  Created by Jonathan Duran on 06/08/2025.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .noData:
            return "No se recibieron datos"
        case .decodingError:
            return "Error al procesar los datos"
        case .networkError(let error):
            return "Error de red: \(error.localizedDescription)"
        case .serverError(let code):
            return "Error del servidor: \(code)"
        }
    }
}

class APIService {
    static let shared = APIService()
    
    private let baseURL = "https://epymygejmvqlnmcbzlox.supabase.co/rest/v1"
    private let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVweW15Z2VqbXZxbG5tY2J6bG94Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ1MjcwMjUsImV4cCI6MjA3MDEwMzAyNX0.Z0hV1N0wdx7YUQU0B5aNckpTxqf7hGauped7aYPEL3w"
    
    private init() {}
    
    // MARK: - Headers
    private var headers: [String: String] {
        return [
            "apikey": apiKey,
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json",
            "Prefer": "return=representation"
        ]
    }
    
    func fetchNotes() async throws -> [Note] {
        guard let url = URL(string: "\(baseURL)/notes") else {
            print("❌ Error: URL inválida para fetchNotes")
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        print("🌐 Fetching notes from: \(url)")
        print("📋 Headers: \(headers)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            print("📥 Response received")
            print("📊 Data size: \(data.count) bytes")
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 HTTP Status: \(httpResponse.statusCode)")
                guard httpResponse.statusCode == 200 else {
                    print("❌ Server error: \(httpResponse.statusCode)")
                    throw APIError.serverError(httpResponse.statusCode)
                }
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 Response data: \(responseString)")
            }
            
            let notes = try JSONDecoder().decode([Note].self, from: data)
            print("✅ Successfully decoded \(notes.count) notes")
            return notes
        } catch let decodingError as DecodingError {
            print("❌ Decoding error: \(decodingError)")
            throw APIError.decodingError
        } catch let apiError as APIError {
            print("❌ API error: \(apiError)")
            throw apiError
        } catch {
            print("❌ Network error: \(error)")
            throw APIError.networkError(error)
        }
    }
    
    func createNote(title: String) async throws -> Note {
        guard let url = URL(string: "\(baseURL)/notes") else {
            print("❌ Error: URL inválida para createNote")
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        let createRequest = CreateNoteRequest(title: title)
        request.httpBody = try JSONEncoder().encode(createRequest)
        
        print("🌐 Creating note at: \(url)")
        print("📝 Title: \(title)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            print("📥 Response received")
            print("📊 Data size: \(data.count) bytes")
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 HTTP Status: \(httpResponse.statusCode)")
                guard httpResponse.statusCode == 201 else {
                    print("❌ Server error: \(httpResponse.statusCode)")
                    throw APIError.serverError(httpResponse.statusCode)
                }
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 Response data: \(responseString)")
            }
            
            let notes = try JSONDecoder().decode([Note].self, from: data)
            guard let newNote = notes.first else {
                print("❌ No note returned from server")
                throw APIError.noData
            }
            
            print("✅ Successfully created note with ID: \(newNote.id)")
            return newNote
        } catch let decodingError as DecodingError {
            print("❌ Decoding error: \(decodingError)")
            throw APIError.decodingError
        } catch let apiError as APIError {
            print("❌ API error: \(apiError)")
            throw apiError
        } catch {
            print("❌ Network error: \(error)")
            throw APIError.networkError(error)
        }
    }
    
    func updateNote(id: String, title: String) async throws -> Note {
        guard let url = URL(string: "\(baseURL)/notes?id=eq.\(id)") else {
            print("❌ Error: URL inválida para updateNote")
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        let updateRequest = UpdateNoteRequest(title: title)
        request.httpBody = try JSONEncoder().encode(updateRequest)
        
        print("🌐 Updating note at: \(url)")
        print("📝 New title: \(title)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            print("📥 Response received")
            print("📊 Data size: \(data.count) bytes")
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 HTTP Status: \(httpResponse.statusCode)")
                guard httpResponse.statusCode == 200 else {
                    print("❌ Server error: \(httpResponse.statusCode)")
                    throw APIError.serverError(httpResponse.statusCode)
                }
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📄 Response data: \(responseString)")
            }
            
            let notes = try JSONDecoder().decode([Note].self, from: data)
            guard let updatedNote = notes.first else {
                print("❌ No updated note returned from server")
                throw APIError.noData
            }
            
            print("✅ Successfully updated note with ID: \(updatedNote.id)")
            return updatedNote
        } catch let decodingError as DecodingError {
            print("❌ Decoding error: \(decodingError)")
            throw APIError.decodingError
        } catch let apiError as APIError {
            print("❌ API error: \(apiError)")
            throw apiError
        } catch {
            print("❌ Network error: \(error)")
            throw APIError.networkError(error)
        }
    }
    
    func deleteNote(id: String) async throws {
        guard let url = URL(string: "\(baseURL)/notes?id=eq.\(id)") else {
            print("❌ Error: URL inválida para deleteNote")
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        print("🌐 Deleting note at: \(url)")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 HTTP Status: \(httpResponse.statusCode)")
                guard httpResponse.statusCode == 204 else {
                    print("❌ Server error: \(httpResponse.statusCode)")
                    throw APIError.serverError(httpResponse.statusCode)
                }
            }
            
            print("✅ Successfully deleted note with ID: \(id)")
        } catch let apiError as APIError {
            print("❌ API error: \(apiError)")
            throw apiError
        } catch {
            print("❌ Network error: \(error)")
            throw APIError.networkError(error)
        }
    }
}

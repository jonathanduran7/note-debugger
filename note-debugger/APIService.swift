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
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    throw APIError.serverError(httpResponse.statusCode)
                }
            }
            
            let notes = try JSONDecoder().decode([Note].self, from: data)
            return notes
        } catch let decodingError as DecodingError {
            throw APIError.decodingError
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func createNote(title: String) async throws -> Note {
        guard let url = URL(string: "\(baseURL)/notes") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        let createRequest = CreateNoteRequest(title: title)
        request.httpBody = try JSONEncoder().encode(createRequest)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 201 else {
                    throw APIError.serverError(httpResponse.statusCode)
                }
            }
            
            let notes = try JSONDecoder().decode([Note].self, from: data)
            guard let newNote = notes.first else {
                throw APIError.noData
            }
            
            return newNote
        } catch let decodingError as DecodingError {
            throw APIError.decodingError
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func updateNote(id: String, title: String) async throws -> Note {
        guard let url = URL(string: "\(baseURL)/notes?id=eq.\(id)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        let updateRequest = UpdateNoteRequest(title: title)
        request.httpBody = try JSONEncoder().encode(updateRequest)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    throw APIError.serverError(httpResponse.statusCode)
                }
            }
            
            let notes = try JSONDecoder().decode([Note].self, from: data)
            guard let updatedNote = notes.first else {
                throw APIError.noData
            }
            
            return updatedNote
        } catch let decodingError as DecodingError {
            throw APIError.decodingError
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func deleteNote(id: String) async throws {
        guard let url = URL(string: "\(baseURL)/notes?id=eq.\(id)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 || httpResponse.statusCode == 204 else {
                    throw APIError.serverError(httpResponse.statusCode)
                }
            }
            
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.networkError(error)
        }
    }
}

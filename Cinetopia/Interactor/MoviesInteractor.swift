//
//  MoviesInteractor.swift
//  Cinetopia
//
//  Created by Vitor Henrique Barreiro Marinho on 17/10/24.
//

import Foundation

protocol MoviesPresenterToInteractor: AnyObject {
    func fetchMovies() async throws -> [Movie]
}

class MoviesInteractor: MoviesPresenterToInteractor {
    private var movieService: MovieService = MovieService()

    func fetchMovies() async throws -> [Movie] {
        do {
            let movies = try await movieService.getMovies()
            return movies
        } catch (let error) {
            throw error
        }
    }
}

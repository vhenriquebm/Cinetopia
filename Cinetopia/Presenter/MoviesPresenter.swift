//
//  MoviesPresenter.swift
//  Cinetopia
//
//  Created by Vitor Henrique Barreiro Marinho on 17/10/24.
//

import UIKit

protocol MoviesPresenterToViewProtocol: AnyObject {
    func didSelect(movie: Movie)
    func didSelectFavoriteButton(_ movie: Movie)
    func didSearchText()
    func didSearchTextsearchBar(_ searchBar: UISearchBar, textDidChange searchText: String, _ movies: [Movie], _ filteredMovies: inout [Movie])
    
}

protocol MoviesPresenterToViewControllerProtocol: AnyObject {
    func setViewController(_ viewController: MoviesViewControllerToPresenterProtocol)
    func viewDidLoad()
    func viewDidAppear()
}

class MoviesPresenter: MoviesPresenterToViewControllerProtocol {
    private var controller: MoviesViewControllerToPresenterProtocol?
    private var view: MoviesViewProtocol?
    private var movieService: MovieService = MovieService()
    
    init(view: MoviesViewProtocol?) {
        self.view = view
    }
    
    func setViewController(_ viewController: any MoviesViewControllerToPresenterProtocol) {
        self.controller = viewController
    }
    
    func viewDidLoad() {
        view?.setPresenter(self)
        
        Task {
            await fetchMovies()
        }
    }
    
    func viewDidAppear() {
        view?.reloadData()
    }
    
    private func fetchMovies() async {
        do {
            let movies = try await movieService.getMovies()
            view?.setupView(with: movies)
            view?.reloadData()
        } catch (let error) {
            print(error)
        }
    }
}


extension MoviesPresenter: MoviesPresenterToViewProtocol {
    func didSelect(movie: Movie) {
        controller?.didSelectMovie(movie)
    }
    
    func didSelectFavoriteButton(_ movie: Movie) {
        // movie.changeSelectionStatus()
        MovieManager.shared.add(selectedMovie)
    }
    
    func didSearchText() {
        
    }
    
    func didSearchTextsearchBar(_ searchBar: UISearchBar, textDidChange searchText: String, _ movies: [Movie], _ filteredMovies: inout [Movie]) {
        if searchText.isEmpty {
            view?.toggle(false)
        } else {
            filteredMovies = movies.filter { movie in
                movie.title.lowercased().contains(searchText.lowercased())
            }
            view?.toggle(true)
        }
    }
}

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
    private var interactor: MoviesPresenterToInteractor?
    
    init(view: MoviesViewProtocol?, interactor: MoviesPresenterToInteractor?) {
        self.view = view
        self.interactor = interactor
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
            guard let movies = try await interactor?.fetchMovies() else { return }
            view?.setupView(with: movies)
            view?.reloadData()
        } catch {
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
        MovieManager.shared.add(movie)
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

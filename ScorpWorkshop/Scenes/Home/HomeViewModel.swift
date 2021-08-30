//
//  HomeViewModel.swift
//  ScorpWorkshop
//
//  Created by Kaan Ozdemir on 30.08.2021.
//  Copyright © 2021 Kaan Ozdemir. All rights reserved.
//

import Foundation

protocol HomeViewModelEventSource {
    var refreshTableView: () -> () { get }
    var reloadTableView: () -> () { get }
    var presentError: (_ error: FetchError) -> () { get }
    var isLoading: (_ loading: Bool) -> () { get }
}

protocol HomeViewModelDataSource {
    var people: [Person] { get }
}

protocol HomeViewModelProtocol: HomeViewModelDataSource, HomeViewModelEventSource {}

class HomeViewModel: HomeViewModelProtocol {
    var isLoading = { (loading: Bool) -> () in }
    
    var people: [Person] = []
    
    var refreshTableView = { () -> () in}
    var reloadTableView = { () -> () in}
    var presentError = { (error: FetchError) -> () in}
    
    var fetchResponse: FetchResponse?
    
    init() {
        
    }
    
    func fetchPeople(_ completionHandler: FetchCompletionHandler? = nil) {
        isLoading(true)
        DataSource.fetch(next: fetchResponse?.next) { [weak self] response, error in
            guard let self = self else { return }
            self.isLoading(false)
            self.fetchResponse = response
            if let error = error {
                self.presentError(error)
                return
            }
            self.people.append(contentsOf: self.getEliminatedPeople(people: response?.people ?? []))
            self.reloadTableView()
        }
    }
    
    func getPersonBy(_ indexPath: IndexPath) -> Person {
        return people[indexPath.row]
    }
    
    func getEliminatedPeople(people: [Person]) -> [Person] {
        var eliminatedPeople: [Person] = []
        people.forEach { person in
            guard !eliminatedPeople.contains(where: { $0.id == person.id }) else { return }
            eliminatedPeople.append(person)
            print("PERSON: \(person.id) - \(person.fullName)")
        }
        
        return eliminatedPeople
    }
    
    func fetchNextSetOfPeopleIfNeeded(_ indexPath: IndexPath) {
        if (people.count - 1) == indexPath.row {
            fetchPeople()
        }
    }
}

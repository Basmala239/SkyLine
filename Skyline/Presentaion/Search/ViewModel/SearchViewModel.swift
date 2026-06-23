//
//  SearchModelView.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 23/06/2026.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject{
    @Published var searchResult: [SearchResult]?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    
    private let getSearchLocationUseCase: SearchLocationUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(getSearchLocationUseCase: SearchLocationUseCaseProtocol = SearchLocationUseCase()) {
        self.getSearchLocationUseCase = getSearchLocationUseCase
        setupSearchDebounce()
    }
    
    func fetchLocation(for city: String) {
        guard !city.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        isLoading = true
        errorMessage = nil

        getSearchLocationUseCase.execute(city: city)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false

                    switch completion {
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        self?.searchResult = nil
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] response in
                    self?.searchResult = response
                    self?.errorMessage = nil
                }
            )
            .store(in: &cancellables)
    }
    
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self = self else { return }
                if !text.isEmpty {
                    self.fetchLocation(for: text)
                }
            }
            .store(in: &cancellables)
    }
}

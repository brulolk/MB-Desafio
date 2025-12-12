//
//  MB_DesafioTests.swift
//  MB-DesafioTests
//
//  Created by Bruno Vinicius on 10/12/25.
//

import XCTest
@testable import MB_Desafio

@MainActor
final class MB_DesafioTests: XCTestCase {
    
    var viewModel: ExchangeListViewModel!
    var mockRepository: MockExchangeRepository!
    var mockFavorites: MockFavoritesRepository!
    var useCase: GetExchangesUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockExchangeRepository()
        mockFavorites = MockFavoritesRepository()
        useCase = GetExchangesUseCase(repository: mockRepository)
        viewModel = ExchangeListViewModel(
            getExchangesUseCase: useCase,
            favoritesRepository: mockFavorites
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        mockFavorites = nil
        useCase = nil
        super.tearDown()
    }
    
    func testFetchExchanges_Success() async {
        mockRepository.shouldReturnError = false
        let expectation = expectation(description: "Deve carregar lista")
        
        viewModel.onStateChanged = { state in
            if case .success = state {
                expectation.fulfill()
            }
        }
        
        viewModel.fetchExchanges()
        await fulfillment(of: [expectation], timeout: 2.0)
        
        XCTAssertEqual(viewModel.displayedExchanges.count, 3)
        XCTAssertEqual(viewModel.displayedExchanges.first?.name, "Binance")
    }
    
    func testFetchExchanges_Failure() async {
        mockRepository.shouldReturnError = true
        let expectation = expectation(description: "Deve retornar erro")
        
        viewModel.onStateChanged = { state in
            if case .error = state {
                expectation.fulfill()
            }
        }
        
        viewModel.fetchExchanges()
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertTrue(viewModel.displayedExchanges.isEmpty)
    }
    
    func testFavoritesFilter() async {
        mockRepository.shouldReturnError = false
        let loadExpectation = expectation(description: "Dados carregados")
        
        viewModel.onStateChanged = { state in
            if case .success = state { loadExpectation.fulfill() }
        }
        
        viewModel.fetchExchanges()
        await fulfillment(of: [loadExpectation], timeout: 1.0)
        
        viewModel.onStateChanged = nil
        
        viewModel.toggleFavorite(exchangeId: 1)
        XCTAssertTrue(mockFavorites.isFavorite(id: 1))
        
        viewModel.filterChanged(to: .favorites)
        
        XCTAssertEqual(viewModel.displayedExchanges.count, 1)
        XCTAssertEqual(viewModel.displayedExchanges.first?.name, "Binance")
    }
    
    func testSearchFeature() async {
        let loadExpectation = expectation(description: "Dados carregados")
        viewModel.onStateChanged = { state in
            if case .success = state { loadExpectation.fulfill() }
        }
        
        viewModel.fetchExchanges()
        await fulfillment(of: [loadExpectation], timeout: 1.0)
        
        viewModel.onStateChanged = nil
        
        viewModel.search(query: "Kraken")
        
        XCTAssertEqual(viewModel.displayedExchanges.count, 1)
        XCTAssertEqual(viewModel.displayedExchanges.first?.name, "Kraken")
        
        viewModel.search(query: "")
        XCTAssertEqual(viewModel.displayedExchanges.count, 3)
    }
}

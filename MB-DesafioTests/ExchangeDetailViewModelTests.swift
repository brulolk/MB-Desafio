//
//  ExchangeDetailViewModelTests.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 12/12/25.
//

import XCTest
@testable import MB_Desafio

@MainActor
final class ExchangeDetailViewModelTests: XCTestCase {
    
    var viewModel: ExchangeDetailViewModel!
    var mockUseCase: MockGetExchangeDetailsUseCase!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockGetExchangeDetailsUseCase()
        viewModel = ExchangeDetailViewModel(exchangeId: 1, useCase: mockUseCase)
    }
    
    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    func testFetchDetails_Success() async {
        mockUseCase.shouldReturnError = false
        
        let expectation = expectation(description: "Carregar detalhes com sucesso")
        
        viewModel.onStateChanged = { state in
            if case .success = state {
                expectation.fulfill()
            }
        }
        
        viewModel.fetch()
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertNotNil(viewModel.detail)
        XCTAssertEqual(viewModel.detail?.name, "Binance")
        XCTAssertEqual(viewModel.coins.count, 1)
        XCTAssertEqual(viewModel.coins.first?.symbol, "BTC")
    }
    
    func testFetchDetails_Failure() async {
        mockUseCase.shouldReturnError = true
        
        let expectation = expectation(description: "Deve retornar erro")
        
        viewModel.onStateChanged = { state in
            if case .error = state {
                expectation.fulfill()
            }
        }
        
        viewModel.fetch()
        
        await fulfillment(of: [expectation], timeout: 1.0)
        
        XCTAssertNil(viewModel.detail)
        XCTAssertTrue(viewModel.coins.isEmpty)
    }
}

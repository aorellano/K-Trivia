//
//  GamesViewTests.swift
//  KTriviaTests
//
//  Created by Alexis Orellano on 7/26/22.
//

import XCTest
import Combine

@testable import KTrivia
class GamesViewTests: XCTestCase {
    var viewModel: GamesViewModel!
    var mockGamesService: MockGamesService!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        mockGamesService = MockGamesService()
        viewModel = .init(service: mockGamesService)
    }
   

    override func tearDown() {
        viewModel = nil
    }
    
    func test_KTrivia_fetchGames_shouldReturnItems() async throws {
        let expectation = XCTestExpectation(description: "Fetched Games")
        await viewModel.fetchGames(with: ["id1"])
        
        viewModel.$games
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(viewModel.games.count, 1)
    }
    
    func test_KTrivia_fetchGames_shouldNotReturnItems() async throws {
        let expectation = XCTestExpectation(description: "Fetched Games")
        await viewModel.fetchGames(with: ["id3"])
        
        viewModel.$games
            .dropFirst()
            .sink { returnedItems in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(viewModel.games.count, 0)
    }
}

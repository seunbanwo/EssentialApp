//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Seun Adebanwo on 19/02/2023.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        //assert how many times it was invoked
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        //Arrange
        let (sut, client) = makeSUT()
        
        //Act
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        let clientError = NSError(domain: "Test", code: 0)
        client.completions[0](clientError)
        
        //Assert
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "https://a-url.com")!
    ) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        
        // Use construstor injection
        // property injection
        // or method injection not singleton
        let sut = RemoteFeedLoader(url: url, client: client)
        
        // return tuple
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        // Make your class a subclass of the abstract class
        // use composition instead of inheritance
        var requestedURLs = [URL]()
        var error: Error?
        var completions = [(Error) -> Void]()
        
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            completions.append(completion)
            requestedURLs.append(url)
        }
    }
}

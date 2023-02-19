//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Seun Adebanwo on 19/02/2023.
//

import XCTest

class RemoteFeedLoader {
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    // Use protocol instead of class.
    // In protocol you dont have implementation just the definition
    func get(from url: URL)
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
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
        
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }
}

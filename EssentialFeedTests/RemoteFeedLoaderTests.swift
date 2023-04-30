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
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        //assert how many times it was invoked
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        //Arrange
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        //Arrange
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code,  data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponseWithInvalidJSON() {
        //Arrange
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON, at: 0)
        })
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        //Arrange
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        //Arrange
        let (sut, client) = makeSUT()

        let item1 = makeItem(id: UUID(), imageURL: URL(string: "http://a-url.com")!)
        let item2 = makeItem(
            id: UUID(),
            description: "a description",
            location: "a loacation",
            imageURL: URL(string: "http://another-url.com")!
        )
        
        let items = [item1.model, item2.model]
        
        expect(sut, toCompleteWith: .success(items), when: {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "https://a-url.com")!,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        
        // Use construstor injection
        // property injection
        // or method injection not singleton
        let sut = RemoteFeedLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        // return tuple
        return (sut, client)
    }
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line : UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated, Potential memory leak.", file: file, line: line)
        }
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.Result,  when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        //Act
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { capturedResults.append($0) }
        action()
        
        //  It’s important to pass the file and line to the
        //  XCTAssert... functions when they are called outside
        //  the test method (e.g., in helper methods). This way,
        //  Xcode can highlight precisely which test failed, and where.
        //Assert
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedItem, json: [String: Any]) {
        // import FeedItem as testable or create initializer
        let item = FeedItem(id: id, description: description, location: location, imageURL: imageURL)
        
        // Since Swift 5, you can use the compactMapValues
        // method instead of reduce to remove nil values from a Dictionary
        let json = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].compactMapValues { $0 }
        
        return (item, json)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = [ "items": items ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    // Spies are usually test-helpers with a
    // single responsibility of capturing the received messages.
    
    // Stubs and Spies are test-doubles.
    //
    //    1. A Stub is used to set predefined behaviors or responses
    // during tests. For example, you can create a Stub to provide
    // "canned" HTTP responses (e.g., predefined JSON data or error).
    //
    //    2. A Spy collects or "records" usage information such as
    // method invocation count and values received. So you can
    // use/verify them later in the test.
    //
    //    A Spy is often also a Stub, as you can choose to
    // set predefined actions/responses into it.
    private class HTTPClientSpy: HTTPClient {
        
        // Make your class a subclass of the abstract class
        // use composition instead of inheritance
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        //  In Swift, closures are "first-class citizens."
        //  Meaning they can be stored as properties or
        //  passed as parameters, for example.
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            
            messages[index].completion(.success(data, response))
        }
    }
}

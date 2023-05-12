//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Seun Adebanwo on 19/02/2023.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    // `public` makes the class accessible from other modules
    // By making final you prevent subclassing
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping(Result) -> Void) {
        client.get(from: url) { [weak self ] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                    completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                    completion(.failure(RemoteFeedLoader.Error .connectivity))
            }
        }
    }
}

//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Seun Adebanwo on 18/02/2023.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure (Error)
}

protocol FeedLoader {
    associatedtype Error: Swift.Error
     
    func load(completion: @escaping (LoadFeedResult<Error>) -> Void)
}

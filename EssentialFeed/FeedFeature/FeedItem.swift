//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Seun Adebanwo on 18/02/2023.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}

//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Oluwaseun Adebanwo on 16/10/2023.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}

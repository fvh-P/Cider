//
//  ImageError.swift
//  Cider
//
//  Created by γ΅γγΌε on 2021/10/02.
//

enum ImageError: Error {
    case forbidden
    case endpointNotFound
    case serviceTemporarilyUnavailable
    case badGateway
    case other(detail: String)
}

//
//  ImageRecordError.swift
//  Cider
//
//  Created by γ΅γγΌε on 2021/09/30.
//

enum ImageRecordError: Error {
    case forbidden
    case endpointNotFound
    case serviceTemporarilyUnavailable
    case badGateway
    case other(detail: String)
}

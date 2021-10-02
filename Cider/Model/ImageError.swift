//
//  ImageError.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/10/02.
//

enum ImageError: Error {
    case forbidden
    case endpointNotFound
    case serviceTemporarilyUnavailable
    case badGateway
    case other(detail: String)
}

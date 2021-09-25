//
//  LoadingState.swift
//  Cider
//
//  Created by kokuriha on 2021/09/25.
//

enum LoadingState: Equatable {
    case loading
    case success
    case failure(msg: String)
}

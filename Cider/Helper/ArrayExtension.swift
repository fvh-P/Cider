//
//  ArrayExtension.swift
//  Cider
//
//  Created by γ΅γγΌε on 2021/10/28.
//

extension Array {
    public func partition(predicate: (Element) -> Bool) -> (include: [Element], exclude: [Element]) {
        return reduce(([], [])) { (acc, x) in
            if predicate(x) {
                return (acc.0 + [x], acc.1)
            } else {
                return (acc.0, acc.1 + [x])
            }
        }
    }
}

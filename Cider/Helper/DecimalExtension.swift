//
//  DecimalExtension.swift
//  Cider
//
//  Created by γ΅γγΌε on 2021/08/09.
//

import Foundation

extension Decimal: LosslessStringConvertible {
    public init?(_ description: String) {
        guard let decimal = Decimal(string: description) else {
            return nil
        }
        self = decimal
    }
}

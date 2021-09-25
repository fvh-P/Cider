//
//  DictionaryHelper.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/19.
//

import Foundation

struct DictionaryHelper {
    public static func initDict(data: Data) -> Dictionary<String, [Triple]> {
        var result: SparqlResponse?
        do {
            result = try JSONDecoder().decode(SparqlResponse.self, from: data)
        } catch {
            fatalError("JSON parse error")
        }
        return Dictionary.init(grouping: (result?.results.bindings)!, by: { (elem) -> String in
            return elem.subject.value
        })
    }
    
    private init() {}
}

//
//  TriplesHelper.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/15.
//

struct TriplesHelper {
    public static func findOne(triples: [Triple], predicate: String, langString: String = "ja") -> Triple? {
        return triples.first(where: { triple -> Bool in
            if triple.predicate.value == predicate {
                guard let lang = triple.object.lang else {
                    return true
                }
                return lang == langString
            }
            else {
                return false
            }
        })
    }

    public static func findMany(triples: [Triple], predicate: String, langString: String = "ja") -> [Triple] {
        return triples.filter({ triple -> Bool in
            if triple.predicate.value == predicate {
                guard let lang = triple.object.lang else {
                    return true
                }
                return lang == langString
            }
            else {
                return false
            }
        })
    }

    private init() {}
}

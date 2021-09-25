//
//  SparqlConstant.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/09/24.
//

import Foundation

struct SparqlConstant {
    static let baseURL = URL(string: "https://lily.fvhp.net/sparql/query")!
    static let lilyListQuery =
"""
PREFIX lily: <https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#>
PREFIX schema: <http://schema.org/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT ?subject ?predicate ?object
WHERE {
    VALUES ?class { lily:Lily lily:Teacher lily:Character lily:Legion }
    VALUES ?predicate {
        schema:name lily:nameKana lily:givenNameKana foaf:age
        lily:rareSkill lily:subSkill lily:isBoosted lily:boostedSkill
        lily:garden lily:grade lily:legion lily:legionJobTitle lily:position
        schema:height schema:weight lily:bloodType lily:alternateName rdf:type
    }
    ?subject a ?class;
             ?predicate ?object.
}
"""
    
    static let lilyDetailQueryTemplate =
"""
PREFIX lilyrdf: <https://lily.fvhp.net/rdf/RDFs/detail/>
PREFIX lily: <https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX schema: <http://schema.org/>
SELECT ?subject ?predicate ?object
WHERE {
    {
        VALUES ?subject { lilyrdf:$slug }
        ?subject ?predicate ?object.
    }
    UNION
    {
        VALUES ?predicate { schema:name schema:alternateName lily:resource lily:usedIn lily:performIn lily:additionalInformation rdf:type }
        lilyrdf:$slug ?rp ?subject.
        ?subject ?predicate ?object.
    }
    UNION
    {
        VALUES ?predicate { schema:productID schema:name rdf:type }
        lilyrdf:$slug lily:charm/lily:resource ?subject.
        ?subject ?predicate ?object.
    }
    UNION
    {
        VALUES ?predicate { schema:name rdf:type }
        lilyrdf:$slug lily:relationship/lily:resource ?subject.
        ?subject ?predicate ?object.
    }
    UNION
    {
        VALUES ?predicate { schema:name rdf:type }
        lilyrdf:$slug schema:sibling/lily:resource ?subject.
        ?subject ?predicate ?object.
    }
    UNION
    {
        VALUES ?predicate { lily:genre schema:name schema:alternateName rdf:type }
        lilyrdf:$slug lily:cast/lily:performIn ?subject.
        ?subject ?predicate ?object.
    }
}
"""
    
    static let charmListQuery =
"""
PREFIX lily: <https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#>
PREFIX schema: <http://schema.org/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT ?subject ?predicate ?object
WHERE {
    VALUES ?class { lily:Charm lily:Corporation }
    VALUES ?predicate {
        schema:productID lily:seriesName schema:name lily:generation lily:requiredSkillerVal schema:manufacturer rdf:type
    }
    ?subject a ?class;
             ?predicate ?object.
}
"""
    
    static let charmDetailQueryTemplate =
"""
PREFIX lily: <https://lily.fvhp.net/rdf/IRIs/lily_schema.ttl#>
PREFIX lilyrdf: <https://lily.fvhp.net/rdf/RDFs/detail/>
PREFIX schema: <http://schema.org/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?subject ?predicate ?object
WHERE{
  {
    VALUES ?subject { lilyrdf:$slug }
    ?subject ?predicate ?object.
  }
  UNION
  {
    VALUES ?rp { lily:user schema:manufacturer lily:isVariantOf lily:hasVariant }
    VALUES ?predicate { schema:name lily:charm rdf:type }
    lilyrdf:$slug ?rp ?subject.
    ?subject ?predicate ?object.
  }
  UNION
  {
    VALUES ?predicate { lily:resource lily:usedIn lily:additionalInformation }
    lilyrdf:$slug lily:user/lily:charm ?subject.
    ?subject lily:resource lilyrdf:$slug;
             ?predicate ?object.
  }
}
"""
}

//
//  RelationshipDisclosureGroup.swift
//  Cider
//
//  Created by ふぁぼ原 on 2021/07/27.
//

import SwiftUI

struct RelationshipListRow: View {
    var relation: Relationship
    var body: some View {
        NavigationLink(destination: LilyDetailView(resource: relation.value.resource)) {
            HStack {
                VStack(alignment: .leading) {
                    ForEach(relation.relation, id:\.self) { r in
                        Text(r)
                    }
                }
                Spacer()
                Text(relation.value.name ?? "N/A")
            }
        }
    }
}

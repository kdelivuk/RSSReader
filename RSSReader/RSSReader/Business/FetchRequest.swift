//
//  FetchRequest.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 27/10/2020.
//

import RealmSwift

struct FetchRequest<Model, RealmObject: Object> {
    let predicate: NSPredicate?
    let sortDescriptors: [SortDescriptor]
    let transformer: (Results<RealmObject>) -> Model
}

extension SortDescriptor {
    static let name = SortDescriptor(keyPath: "name", ascending: true)
}

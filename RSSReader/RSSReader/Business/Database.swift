//
//  Database.swift
//  RSSReader
//
//  Created by Kristijan Delivuk on 26/10/2020.
//

import RealmSwift

final class Database {
    
    let realm: Realm
    
    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    // Inside Database class
    func createOrUpdate<Model, RealmObject: Object>(model: Model, with reverseTransformer: (Model) -> RealmObject) {
        let object = reverseTransformer(model)
        try! realm.write {
            realm.add(object, update: .all)
        }
    }
        
    func fetch<Model, RealmObject>(with request: FetchRequest<Model, RealmObject>) -> Model {
        var results = realm.objects(RealmObject.self)
        
        if let predicate = request.predicate {
            results = results.filter(predicate)
        }
        
        if request.sortDescriptors.count > 0 {
            results = results.sorted(by: request.sortDescriptors)
        }
        
        return request.transformer(results)
    }
    
    func delete<RealmObject: Object>(type: RealmObject.Type, with primaryKey: String) {
        let object = realm.object(ofType: type, forPrimaryKey: primaryKey)
        if let object = object {
            try! realm.write {
                realm.delete(object)
            }
        }
    }
    
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}

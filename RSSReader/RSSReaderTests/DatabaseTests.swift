//
//  DatabaseTests.swift
//  RSSReaderTests
//
//  Created by Kristijan Delivuk on 27/10/2020.
//

import XCTest
import RealmSwift
@testable import RSSReader

class DatabaseTests: XCTestCase {
    
    // MARK: - Public properties
    
    var database: Database!
    
    // MARK: - Class lifecycle
    
    override func setUp() {
        super.setUp()
        let config = Realm.Configuration(inMemoryIdentifier: "delivuk.kristijan.RSSReader")
        
        let realm = try! Realm(configuration: config)
        database = Database(realm: realm)
    }
    
    override func tearDown() {
        database.deleteAll()
        database = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testCreatingFeed() {
        let newRSSFeed = RSSFeedItem.sata24Sports
        
        database.createOrUpdate(model: newRSSFeed, with: RSSFeedItemObject.init)
        database.checkIfCreated(newFeed: newRSSFeed)
    }
    
    func testDeletingFeed() {
        let newRSSFeed = RSSFeedItem.sata24Sports
        database.createOrUpdate(model: newRSSFeed, with: RSSFeedItemObject.init)
        
        let feedInDB = database.fetch(with: RSSFeedItem.all).first!
        
        database.delete(type: RSSFeedItemObject.self, with: feedInDB.ID)
        database.checkIfDeleted()
    }
}

extension Database {
    func checkIfCreated(newFeed: RSSFeedItem, file: StaticString = #file, line: UInt = #line) {
        let results = fetch(with: RSSFeedItem.all)
        XCTAssertEqual(results.count, 1, "results count", file: file, line: line)
        
        let feedInDatabase = results.first!
        XCTAssertEqual(feedInDatabase.name, newFeed.name, "name", file: file, line: line)
        XCTAssertEqual(feedInDatabase.url, newFeed.url, "comment", file: file, line: line)
    }
    
    func checkIfDeleted(file: StaticString = #file, line: UInt = #line) {
        let results = fetch(with: RSSFeedItem.all)
        XCTAssertEqual(results.count, 0, "results count", file: file, line: line)
    }
}

//
//  BySykkelUITests.swift
//  BySykkelUITests
//
//  Created by Torp, Thomas on 14/09/2018.
//  Copyright © 2018 Torp. All rights reserved.
//

import XCTest

class BySykkelUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        app.launch()
    }
    
    func testThatItsPossibleToChangeToMap() {
        let tableView = app.tables.firstMatch
        waitFor(element: tableView)

        let cell = tableView.cells.staticTexts["157 - Nylandsveien"]
        waitFor(element: cell)

        XCTAssertEqual(tableView.cells.count, 237)

        let tabBarItem = app.tabBars.firstMatch.buttons["Map"]
        tabBarItem.tap()

        let map = app.maps.firstMatch
        waitFor(element: map)

        map.pinch(withScale: 10, velocity: 1)

        let marker = map.otherElements["163 - Vaterlandsparken"]
        waitFor(element: marker)
        marker.tap()
    }
    
}

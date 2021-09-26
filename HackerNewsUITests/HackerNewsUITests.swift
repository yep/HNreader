//
//  HackerNewsUITests.swift
//  HackerNewsUITests
//

import XCTest

class HackerNewsUITests: XCTestCase {
    var app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Open "Report Navigator" to see screenshots
    func testScreenshots() throws {
        waitForCell(index: 1)
        takeScreenshot(name: "01-Main")
        
        tapCell(index: 1)
        takeScreenshot(name: "02-Comments")

        tapCell(index: 0)
        takeScreenshot(name: "03-Detail")

        tapCell(index: 0)
        Thread.sleep(forTimeInterval: 1)
        takeScreenshot(name: "04-Browser")
    }
    
    fileprivate func tapCell(index: Int) {
        app.tables.cells.element(boundBy: index).tap()
        waitForCell(index: index)
    }
    
    fileprivate func waitForCell(index: Int) {
        _ = XCUIApplication().tables.cells.element(boundBy: index).waitForExistence(timeout: 10)
    }
    
    fileprivate func takeScreenshot(name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

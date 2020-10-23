//
//  RetainCycleTests.swift
//  WandioCoreComponentsTests
//
//  Created by Kakhi Kiknadze on 10/23/20.
//

import XCTest
@testable import WandioCoreComponents



class MockSheetDelegate: WandioBottomSheetDelegate {
    
}

class RetainCycleTests: XCTestCase {
    
    func testBottomSheetDelegate() {
        let sheet = WandioBottomSheet()
        var delegate = MockSheetDelegate()
        sheet.delegate = delegate
        delegate = MockSheetDelegate()
        XCTAssertNil(sheet.delegate)
    }
    
    func testWandioBottomSheet() {
        var sheet: WandioBottomSheet? = .init()
        weak var weakSheet = sheet
        sheet = nil
        XCTAssertNil(weakSheet)
        //assertNil(weakSheet, after: { sheet = nil} )
    }

}

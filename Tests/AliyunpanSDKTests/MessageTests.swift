//
//  MessageTests.swift
//  AliyunpanSDKTests
//
//  Created by zhaixian on 2023/12/5.
//

import XCTest
@testable import AliyunpanSDK

extension AliyunpanAuthorizeError: Equatable {
    var stringValue: String {
        switch self {
        case .invaildAuthorizeURL:
            return "invaildAuthorizeURL"
        case .notInstalledApp:
            return "notInstalledApp"
        case .authorizeFailed(let error, let errorMsg):
            return "authorizeFailed_\(error ?? "")_\(errorMsg ?? "")"
        }
    }
    
    public static func == (lhs: AliyunpanAuthorizeError, rhs: AliyunpanAuthorizeError) -> Bool {
        lhs.stringValue == rhs.stringValue
    }
}

class MessageTests: XCTestCase {
    func testAliyunpanMessage() throws {
        let state = Date().timeIntervalSince1970
        
        let url1 = URL(string: "smartdrive://authorize?state=\(state)")!
        let message1 = try AliyunpanMessage(url1)
        XCTAssertEqual(message1.action, "authorize")
        XCTAssertEqual(message1.state, "\(state)")
        XCTAssertEqual(message1.originalURL, url1)
        XCTAssertEqual(message1.id, "authorize_\(state)")
        
        let url2 = URL(string: "abcd://authorize?state=\(state)")!
        XCTAssertThrowsError(try AliyunpanMessage(url2)) { error in
            XCTAssertEqual(error as! AliyunpanAuthorizeError, AliyunpanAuthorizeError.invaildAuthorizeURL)
        }
    }
    
    func testAliyunpanAuthMessage() throws {
        let state = Date().timeIntervalSince1970
        let code = "abcd"
        
        let url1 = URL(string: "smartdrive123456://authorize?state=\(state)&code=\(code)")!
        let message1 = try AliyunpanAuthorizeMessage(url1)
        XCTAssertEqual(message1.action, "authorize")
        XCTAssertEqual(message1.state, "\(state)")
        XCTAssertEqual(message1.authCode, code)
        XCTAssertEqual(message1.originalURL, url1)
        XCTAssertEqual(message1.id, "authorize_\(state)")
        
        let url2 = URL(string: "abcd://authorize?state=\(state)&code=\(code)")!
        XCTAssertThrowsError(try AliyunpanAuthorizeMessage(url2)) { error in
            XCTAssertEqual(error as! AliyunpanAuthorizeError, AliyunpanAuthorizeError.invaildAuthorizeURL)
        }
    }
}

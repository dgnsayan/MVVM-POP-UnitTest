//
//  RootViewModelTest.swift
//  MVVM with POPTests
//
//  Created by Doğan Sayan on 20.05.2022.
//

import XCTest
@testable import MVVM_with_POP

class RootViewModelTest: XCTestCase {

    private var sut : RootViewModel!
    private var userService : MockUserService!
    private var loginStorageService : MockLoginStorageService!
    private var output : MockRootViewModelOutput!
    
    override func setUpWithError() throws {
        userService = MockUserService()
        loginStorageService = MockLoginStorageService()
        output = MockRootViewModelOutput()
        sut = RootViewModel(loginStorageService: loginStorageService, userService: userService)
        sut.output = output
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        userService = nil
        loginStorageService = nil
        try super.tearDownWithError()
    }

    func testShowLogin_whenLoginStorageReturnsEmptyUserToken() {
        //given
        loginStorageService.dict = [:]
        //when
        sut.processFlow()
        //then
        XCTAssertEqual(output.flow.count, 1)
        XCTAssertEqual(output.flow[0], .login)
    }
    
    func testShowLogin_whenLoginStorageReturnEmptyStringUserToken_isCalled() {
        //given
        loginStorageService.dict["ACCESS_TOKEN"] = ""
        //when
        sut.processFlow()
        //then
        XCTAssertEqual(output.flow.count, 1)
        XCTAssertEqual(output.flow[0], .login)
    }
    
    func testShowMainApp_whenLoginStorageReturnsUserToken_isCalled() {
        //given
        loginStorageService.dict["ACCESS_TOKEN"] = UUID().uuidString
        //when
        sut.processFlow()
        //then
        XCTAssertEqual(output.flow.count, 1)
        XCTAssertEqual(output.flow[0], .mainApp)
    } 
    
}


class MockLoginStorageService: LoginStorageService {
    var accessTokenKey: String{
        return "ACCESS_TOKEN"
    }
    
    var dict:[String:String] = [:]
    
    func setUserAccessToken(value: String) {
        dict[accessTokenKey] = value
    }
    
    func getUserAccessToken() -> String? {
        return dict[accessTokenKey]
    }
}

class MockRootViewModelOutput: RootViewModelOutput {
    
    enum Flow {
        case login
        case mainApp
    }
    
    var flow:[Flow] = []
    
    func showLogin() {
        flow.append(.login)
    }
    
    func showMainApp(userService: UserService) {
        flow.append(.mainApp)
    }
}

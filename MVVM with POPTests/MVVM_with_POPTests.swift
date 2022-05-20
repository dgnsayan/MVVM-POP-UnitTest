//
//  MVVM_with_POPTests.swift
//  MVVM with POPTests
//
//  Created by Doğan Sayan on 19.05.2022.
//

import XCTest
@testable import MVVM_with_POP

class MVVM_with_POPTests: XCTestCase {

    private var sut : UserViewModel!
    private var userService : MockUserService!
    private var output : MockUserViewModelOutput!
    
    override func setUpWithError() throws {
        output = MockUserViewModelOutput()
        userService = MockUserService()
        sut = UserViewModel(userService: userService)
        sut.output = output
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        userService = nil
        try super.tearDownWithError()
    }
    
    func testUpdateView_onAPISuccess_showsImageAndEmail(){
        //given
        let user = User(id: 1, email: "me@me.com", avatar: "https://www.picsum.com/2")
        userService.fetchUserMockResult = .success(user)
        //when
        sut.fetchUser()
        //then
        XCTAssertEqual(output.updateViewArray.count, 1)
        XCTAssertEqual(output.updateViewArray[0].email, "me@me.com")
        XCTAssertEqual(output.updateViewArray[0].imageUrl, "https://www.picsum.com/2")
    }
    
    func testUpdateView_onAPIFailure_showsErrorImageAndDefaultNoUserFoundText(){
        //given
        userService.fetchUserMockResult = .failure(NSError())
        //when
        sut.fetchUser()
        //then
        XCTAssertEqual(output.updateViewArray.count, 1)
        XCTAssertEqual(output.updateViewArray[0].email, "No user found")
        XCTAssertEqual(output.updateViewArray[0].imageUrl, "https://cdn4.iconfinder.com/data/icons/pretty_office_3/256/Male-User-Warning.png")
    }
}
class MockUserService: UserService {
    var fetchUserMockResult : Result<User, Error>?
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        if let result = fetchUserMockResult{
            completion(result)
        }
    }
}

class MockUserViewModelOutput : UserViewModelOutput{
    var updateViewArray : [(imageUrl:String,email:String)] = []
    func updateView(imageUrl: String, email: String) {
        updateViewArray.append((imageUrl, email))
    }
}

//
//  RootViewController.swift
//  MVVM with POP
//
//  Created by Doğan Sayan on 20.05.2022.
//

import UIKit

protocol RootViewModelOutput:AnyObject {
    func showLogin()
    func showMainApp(userService: UserService)
}

class RootViewModel {
    private let loginStorageService:LoginStorageService
    private let userService : UserService
    
    weak var output : RootViewModelOutput?
    
    init(loginStorageService:LoginStorageService,userService : UserService) {
        self.loginStorageService = loginStorageService
        self.userService = userService
    }
    
    func processFlow(){
        if let accessToken = loginStorageService.getUserAccessToken(), !accessToken.isEmpty{
            //User has already logged in previously -> Show Main App
            output?.showMainApp(userService: userService)
        }else{
            //User has not logged in -> Show Login Screen
            output?.showLogin()
        }
    }
}

class RootViewController: UIViewController,RootViewModelOutput {
    
    private let viewModel : RootViewModel
    
    init(viewModel : RootViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.output = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.processFlow()
    }
    
    //MARK: RootViewModelOutput
    func showMainApp(userService: UserService){
        let viewModel = UserViewModel(userService: userService)
        let userViewController = UserViewController(viewModel: viewModel)
        navigationController?.present(userViewController, animated: true, completion: nil)
    }
    
    func showLogin(){
        let loginViewController = LoginViewController()
        navigationController?.present(loginViewController, animated: true, completion: nil)
    }
}

protocol LoginStorageService{
    var accessTokenKey : String { get }
    func setUserAccessToken(value:String)
    func getUserAccessToken() -> String?
}

class StorageManager:LoginStorageService{
    
    //This is not best way to login control anyway
    // Research keychain
    private let storage = UserDefaults.standard
    
    var accessTokenKey: String{
        return "ACCESS_TOKEN"
    }
    
    func setUserAccessToken(value: String) {
        storage.set(value, forKey: accessTokenKey)
    }
    
    func getUserAccessToken() -> String? {
       return storage.string(forKey: accessTokenKey)
    }
    
    
}

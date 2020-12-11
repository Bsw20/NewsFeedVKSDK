//
//  AuthViewController.swift
//  NewsFeedVKSDK
//
//  Created by Ярослав Карпунькин on 09.10.2020.
//

import Foundation
import UIKit

class AuthViewController: UIViewController {
    private var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authService = SceneDelegate.shared().authService
        view.backgroundColor = .white
    }
    @IBAction func signInTouch(_ sender: UIButton) {
        authService.wakeUpSession()
    }
}

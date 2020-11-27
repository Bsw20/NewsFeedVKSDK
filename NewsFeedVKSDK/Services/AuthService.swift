//
//  AuthService.swift
//  NewsFeedVKSDK
//
//  Created by Ярослав Карпунькин on 09.10.2020.
//

import Foundation
import VK_ios_sdk

class AuthService : NSObject{
    private let appId = "7623089"
    private let vkSdk: VKSdk
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("vkSdk initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
}

extension AuthService: VKSdkDelegate, VKSdkUIDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
    
    
}

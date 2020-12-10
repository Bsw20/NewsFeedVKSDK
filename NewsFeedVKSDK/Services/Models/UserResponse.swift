//
//  UserResponse.swift
//  NewsFeedVKSDK
//
//  Created by Ярослав Карпунькин on 10.12.2020.
//

import Foundation
import UIKit

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String?
}

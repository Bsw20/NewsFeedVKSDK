//
//  NewsfeedModels.swift
//  NewsFeedVKSDK
//
//  Created by Ярослав Карпунькин on 06.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Newsfeed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getNewsFeed
        case getUser
        case revealPostIds(postId: Int)
        case getNextBatch
      }
    }
    struct Response {
      enum ResponseType {
        case presentNewsFeed(feed: FeedResponse, revealdedPostIds: [Int])
        case presentUserInfo(user: UserResponse?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayNewsfeed(feedViewModel: FeedViewModel)
        case displayUser(userViewModel: UserViewModel)
      }
    }
  }
  
}

struct UserViewModel: TitleViewViewModel {
    var photoUrlString: String?
}


struct FeedViewModel {
    struct Cell: FeedCellViewModel {

        var postId: Int

        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var photoAttachments: [FeedCellPhotoAttachmentViewModel]
        var sizes: FeedCellSizes

    }
    struct FeedCellPhotoAttachment: FeedCellPhotoAttachmentViewModel {
        var photoUrlString: String?
        var width: Int
        var height: Int
        
    }
    
    let cells: [Cell]
}

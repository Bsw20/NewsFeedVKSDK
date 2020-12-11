//
//  NewsfeedInteractor.swift
//  NewsFeedVKSDK
//
//  Created by Ярослав Карпунькин on 06.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedBusinessLogic {
  func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {

  var presenter: NewsfeedPresentationLogic?
  var service: NewsfeedService?
    
    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }
        
        switch request {
        
        case .getNewsFeed:
            service?.getFeed(completion: { [weak self](revealedPostIds, feed) in
                self?.presenter?.presentData(response: .presentNewsFeed(feed: feed, revealdedPostIds: revealedPostIds))
            })
        case .getUser:
            service?.getUser(completion: { [weak self] (user) in
                self?.presenter?.presentData(response: .presentUserInfo(user: user))
            })
        case .revealPostIds(postId: let postId):
            service?.revealPostIds(forPostId: postId, completion: { [weak self](revealedPostIds, feed) in
                self?.presenter?.presentData(response: .presentNewsFeed(feed: feed, revealdedPostIds: revealedPostIds))
            })
        case .getNextBatch:
            print(123)
            service?.getNextBatch(completion: { [weak self] (revealedPostIds, feed) in
                self?.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsFeed(feed: feed, revealdedPostIds: revealedPostIds))
            })
        }
    }
    
    
  
    
}

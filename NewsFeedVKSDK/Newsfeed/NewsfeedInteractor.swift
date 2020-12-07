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
    
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
  
  func makeRequest(request: Newsfeed.Model.Request.RequestType) {
    if service == nil {
      service = NewsfeedService()
    }
    
    switch request {
    case .getNewsFeed:
        fetcher.getFeed { [weak self] (feedResponse) in
            guard let feedResponse = feedResponse else  { return }
            feedResponse.items.forEach { (item) in
                print(item.attachments)
            }
            self?.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsFeed(feed: feedResponse))
        }
    }
  }
  
}

//
//  FeedViewController.swift
//  NewsFeedVKSDK
//
//  Created by Ярослав Карпунькин on 27.11.2020.
//

import Foundation
import UIKit

class FeedViewController: UIViewController {
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        fetcher.getFeed { (feedResponse) in
            guard let feedResponse = feedResponse else  { return }
            feedResponse.items.map { (feedItem) in
                print(feedItem.date)
            }
        }
    }
}

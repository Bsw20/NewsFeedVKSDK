//
//  NewsfeedViewController.swift
//  NewsFeedVKSDK
//
//  Created by Ярослав Карпунькин on 06.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedDisplayLogic: class {
  func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData)
}

class NewsfeedViewController: UIViewController, NewsfeedDisplayLogic {


    var interactor: NewsfeedBusinessLogic?
  var router: (NSObjectProtocol & NewsfeedRoutingLogic)?
    private var feedViewModel = FeedViewModel.init(cells: [], footerTitle: nil)
    @IBOutlet weak var table: UITableView!
    private var titleView = TitleView()
    private lazy var footerView = FooterView()

    private var refreshControl: UIRefreshControl =  {
        let refreshControl = UIRefreshControl()

        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()

  // MARK: Object lifecycle


  // MARK: Setup

  private func setup() {
    let viewController        = self
    let interactor            = NewsfeedInteractor()
    let presenter             = NewsfeedPresenter()
    let router                = NewsfeedRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }

  // MARK: Routing



  // MARK: View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupTable()
    setupTopBar()


    table.separatorStyle = .none
    table.backgroundColor = .clear
    interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.getNewsFeed)
    interactor?.makeRequest(request: .getUser)
  }
    private func setupTopBar() {
//        let topBar = UIView(frame: UIApplication.shared.statusBarFrame)
//        topBar.backgroundColor = .white
//        topBar.layer.shadowColor = UIColor.black.cgColor
//        topBar.layer.shadowOpacity = 0.3
//        topBar.layer.shadowOffset = CGSize.zero
//        topBar.layer.shadowRadius = 8
//        self.view.addSubview(topBar)
        
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.titleView = titleView
    }

  func displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData) {
    switch viewModel {

    case .displayNewsfeed(feedViewModel: let feedViewModel):
        self.feedViewModel = feedViewModel
        footerView.setTitle(feedViewModel.footerTitle)
        table.reloadData()
        self.refreshControl.endRefreshing()
    case .displayUser(userViewModel: let userViewModel):
        titleView.set(userViewModel: userViewModel)
    case .displayFooterLoader:
        footerView.showLoader()
    }
  }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            interactor?.makeRequest(request: .getNextBatch)
        }
    }

    private func setupTable() {
        let topInset: CGFloat = 8
        
        table.contentInset.top = topInset
        
        table.register(UINib(nibName: "NewsfeedCell", bundle: nil), forCellReuseIdentifier: NewsfeedCell.reuseId)
        table.register(NewsfeedCodeCell.self, forCellReuseIdentifier: NewsfeedCodeCell.reuseId)

        table.separatorStyle = .none
        table.backgroundColor = .clear

        table.addSubview(refreshControl)
        table.tableFooterView = footerView
    }

    @objc private func refresh() {
        interactor?.makeRequest(request: .getNewsFeed)
    }
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedCodeCell.reuseId, for: indexPath) as! NewsfeedCodeCell
        let cellViewModel = feedViewModel.cells[indexPath.row]

        cell.set(viewModel: cellViewModel)
        cell.delegate = self
//        cell.moreTextButton.addTarget(self, action: #selector(test), for: .touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return feedViewModel.cells[indexPath.row].sizes.totalHeight
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return feedViewModel.cells[indexPath.row].sizes.totalHeight
    }

}

extension NewsfeedViewController: NewsfeedCodeCellDelegate {
    func revealPost(for cell: NewsfeedCodeCell) {
        guard let indexPath = table.indexPath(for: cell) else { return }
        let cellViewModel = feedViewModel.cells[indexPath.row]

        interactor?.makeRequest(request: Newsfeed.Model.Request.RequestType.revealPostIds(postId: cellViewModel.postId))

    }


}


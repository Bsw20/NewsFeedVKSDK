//
//  NewsfeedCodeCell.swift
//  NewsFeedVKSDK
//
//  Created by Ярослав Карпунькин on 07.12.2020.
//

import Foundation
import UIKit

protocol NewsfeedCodeCellDelegate: class {
    func revealPost(for cell: NewsfeedCodeCell)
}

final class NewsfeedCodeCell: UITableViewCell {

    static let reuseId = "NewsfeedCodeCell"
    
    weak var delegate: NewsfeedCodeCellDelegate?
    
    let cardView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()

    let topView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let postLabel: UITextView = {
       let textView = UITextView()
        textView.font = Constants.postLabelFont
        textView.isScrollEnabled = false
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        
        let padding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset = UIEdgeInsets.init(top: 0, left: -padding, bottom: 0, right: -padding)
        textView.dataDetectorTypes = UIDataDetectorTypes.all
        return textView
    }()
    let postImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.3098039216, blue: 0.3294117647, alpha: 1)
        return imageView
    }()

    let bottomView: UIView = {
       let view = UIView()
        return view
    }()

    let moreTextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(#colorLiteral(red: 0.4, green: 0.6235294118, blue: 0.831372549, alpha: 1), for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.setTitle("Показать полностью...", for: .normal)
        return button
    }()
    
    let galleryCollectionView = GalleryCollectionView()

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.set(imageURL: nil)
        postImageView.set(imageURL: nil
        )
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        addSubview(cardView)
        cardView.addSubview(topView)



        overlayFirstLayer()
        overlaySecondLayer()
        overlayThirdLayerOnTopView()
        overlayThirdLayerBottomView()
        overlayFourthLayerOnBottomViewViews()

        moreTextButton.addTarget(self, action: #selector(moreTextButtonTouch), for: .touchUpInside)
    }

    @objc func moreTextButtonTouch() {
        print("123")
        delegate?.revealPost(for: self)
    }

    func set(viewModel: FeedCellViewModel) {

        iconImageView.set(imageURL: viewModel.iconUrlString)
        iconImageView.layer.cornerRadius = Constants.topViewHeight / 2
        iconImageView.clipsToBounds = true

        namelabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        sharesLabel.text = viewModel.shares
        viewsLabel.text = viewModel.views

        postLabel.frame = viewModel.sizes.postLabelFrame

        bottomView.frame = viewModel.sizes.bottomViewFrame
        moreTextButton.frame = viewModel.sizes.moreTextButtonFrame

//        if let photoAttachment = viewModel.photoAttachment {
//            postImageView.set(imageURL: photoAttachment.photoUrlString)
//            postImageView.isHidden = false
//        } else {
//            postImageView.isHidden = true
//        }
        if let photoAttachment = viewModel.photoAttachments.first, viewModel.photoAttachments.count == 1 {
            postImageView.set(imageURL: photoAttachment.photoUrlString)
            postImageView.isHidden = false
            galleryCollectionView.isHidden = true
            postImageView.frame = viewModel.sizes.attachmentFrame
        } else if viewModel.photoAttachments.count > 1 {
            galleryCollectionView.frame = viewModel.sizes.attachmentFrame
            postImageView.isHidden = true
            galleryCollectionView.isHidden = false
            galleryCollectionView.set(photos: viewModel.photoAttachments)
        } else {
            postImageView.isHidden = true
            galleryCollectionView.isHidden = true
        }
    }

    private func overlayFirstLayer() {
        contentView.addSubview(cardView)

        //cardView constraints
        cardView.fillSuperview(padding: Constants.cardInsets)
    }

    private func overlaySecondLayer() {
        cardView.addSubview(topView)
        cardView.addSubview(postLabel)
        cardView.addSubview(postImageView)
        cardView.addSubview(galleryCollectionView)
        cardView.addSubview(bottomView)
        cardView.addSubview(moreTextButton)

        //topView constraints
        topView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8).isActive = true
        topView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8).isActive = true
        topView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8).isActive = true
        topView.heightAnchor.constraint(equalToConstant: Constants.topViewHeight).isActive = true
    }

    //Третий слой
    private func overlayThirdLayerOnTopView() {
        topView.addSubview(iconImageView)
        topView.addSubview(namelabel)
        topView.addSubview(dateLabel)

        //iconImageView constraints
        iconImageView.leadingAnchor.constraint(equalTo: topView.leadingAnchor).isActive = true
        iconImageView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: Constants.topViewHeight).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: Constants.topViewHeight).isActive = true

        //nameLabel constraints
        namelabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
        namelabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        namelabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 2).isActive = true
        namelabel.heightAnchor.constraint(equalToConstant: Constants.topViewHeight / 2 - 2).isActive = true

        //dateLabel constraints
        dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -2).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
    }

    private func overlayThirdLayerBottomView() {
        bottomView.addSubview(likesView)
        bottomView.addSubview(commentsView)
        bottomView.addSubview(sharesView)
        bottomView.addSubview(viewsView)

        // likesView constraints
        likesView.anchor(top: bottomView.topAnchor,
                         leading: bottomView.leadingAnchor,
                         bottom: nil,
                         trailing: nil,
                         size: CGSize(width: Constants.bottomViewViewWidth, height: Constants.bottomViewHeight))

        commentsView.anchor(top: bottomView.topAnchor,
                         leading: likesView.trailingAnchor,
                         bottom: nil,
                         trailing: nil,
                         size: CGSize(width: Constants.bottomViewViewWidth, height: Constants.bottomViewHeight))

        sharesView.anchor(top: bottomView.topAnchor,
                         leading: commentsView.trailingAnchor,
                         bottom: nil,
                         trailing: nil,
                         size: CGSize(width: Constants.bottomViewViewWidth, height: Constants.bottomViewHeight))

        viewsView.anchor(top: bottomView.topAnchor,
                         leading: nil,
                         bottom: nil,
                         trailing: bottomView.trailingAnchor,
                         size: CGSize(width: Constants.bottomViewViewWidth, height: Constants.bottomViewHeight))


    }

    let likesView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let commentsView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let sharesView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let viewsView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let iconImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let namelabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
        return label
    }()

    let dateLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    //четвертый слой на bottom view
    let likesImage: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "like")
        return imageView
    }()

    let commentsImage: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "comment")
        return imageView
    }()

    let sharesImage: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "share")
        return imageView
    }()

    let viewsImage: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "eye")
        return imageView
    }()

    let likesLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        return label
    }()

    let commentsLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        return label
    }()
    let sharesLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        return label
    }()
    let viewsLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.lineBreakMode = .byClipping
        label.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        return label
    }()

    private func overlayFourthLayerOnBottomViewViews() {
        likesView.addSubview(likesImage)
        likesView.addSubview(likesLabel)

        commentsView.addSubview(commentsImage)
        commentsView.addSubview(commentsLabel)

        sharesView.addSubview(sharesImage)
        sharesView.addSubview(sharesLabel)

        viewsView.addSubview(viewsImage)
        viewsView.addSubview(viewsLabel)

        helpInFourLayer(view: likesView, imageView: likesImage, label: likesLabel)
        helpInFourLayer(view: commentsView, imageView: commentsImage, label: commentsLabel)
        helpInFourLayer(view: sharesView, imageView: sharesImage, label: sharesLabel)
        helpInFourLayer(view: viewsView, imageView: viewsImage, label: viewsLabel)
    }

    private func helpInFourLayer(view: UIView, imageView: UIImageView, label: UILabel) {

        //imageView constraints
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Constants.bottomViewViewsIconSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.bottomViewViewsIconSize).isActive = true

        //label constraints
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


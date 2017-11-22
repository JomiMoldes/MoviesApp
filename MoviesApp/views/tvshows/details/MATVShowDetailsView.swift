//
// Created by MIGUEL MOLDES on 20/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import UIKit

class MATVShowDetailsView : UIView {

    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subscribeButton: MASubscribeButton!
    @IBOutlet weak var titleViewYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var descHeightConstraint: NSLayoutConstraint!

    var firstMultiplier: CGFloat = 0.0

    var flyerThumb: UIImageView!

    let longScroll: CGFloat = 0.5
    let shortScroll: CGFloat = 1.0

    var model : MATVShowDetailsViewModel! {
        didSet {
            self.bind()
            self.setup()
        }
    }

    var userDidScroll = false

    func viewDidAppear() {
        self.animateFlyer()
        self.animateTitle()
    }

    func viewDidLayoutSubviews() {
        if userDidScroll {
            let scroll = isRotated() ? self.shortScroll : self.longScroll
            self.animateScroll(withMultiplier: scroll)
        }
    }

    //MARK - Private

    fileprivate func bind() {

    }

    fileprivate func setup() {

        self.firstMultiplier = self.titleViewYConstraint.multiplier

        self.setupThumb()
        self.setupBackground()
        self.setupThumbView()

        self.subscribeButton.alpha = 0.0
        self.setupLabels()
        self.setupDescText()
        self.setupScrollView()
        self.setupFlyerThumb()

    }

    fileprivate func setupBackground() {
        self.backgroundImageView.alpha = 0.0
        self.backgroundImageView.image = model.backImage

        self.backgroundImageView.image = self.model.backImage?.tint(with: UIColor.black, blendMode: .color)

        self.bgView.backgroundColor = self.model.backgroundColor
        self.bgView.alpha = 0.0
    }

    fileprivate func setupThumbView() {
        self.thumbnailView.alpha = 0.0
    }

    fileprivate func setupFlyerThumb() {
        self.flyerThumb = UIImageView(image: model.image)
        self.flyerThumb.frame = model.imageRect
        self.addSubview(self.flyerThumb)
    }

    fileprivate func animateFlyer() {

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.flyerThumb.frame = self.thumbnailView.frame
            self.backgroundImageView.alpha = 0.1
            self.bgView.alpha = 1.0
        }, completion: {
            success in
            self.thumbnailView.alpha = 1.0
            self.flyerThumb.image = nil
        })

    }

    fileprivate func setupThumb() {
        self.thumbnailView.layer.cornerRadius = 6.0
        self.thumbnailView.clipsToBounds = true
        self.thumbnailView.image = model.image

        self.backgroundImageView.alpha = 0.1
        self.bgView.alpha = 1.0

    }

    fileprivate func setupScrollView() {
        self.scrollView.delegate = self
    }

    fileprivate func setupLabels() {

        var year: String = ""
        if let date = model.tvShow.airDate {
            year = "\(date.getYear())"
        }
        let str = model.tvShow.name + "\n" + year
        let attributed = NSMutableAttributedString(string: str)

        let spaceIndex = model.tvShow.name.count

        let fontSize = self.titleLabel.font.pointSize

        attributed.addAttribute(NSFontAttributeName, value:UIFont(name: self.titleLabel.font.fontName, size: fontSize) as Any, range:NSMakeRange(0, spaceIndex))
        attributed.addAttribute(NSFontAttributeName, value:UIFont(name: "Helvetica", size: fontSize * 0.7) as Any, range:NSMakeRange(spaceIndex, year.count + 1))

        self.titleLabel.attributedText = attributed

        self.overviewLabel.alpha = 0.0
    }

    fileprivate func setupDescText() {
        self.descTextView.text = model.tvShow.overview
        self.descTextView.alpha = 0.0
        self.descTextView.isScrollEnabled = false
        self.descTextView.isSelectable = false

        var diff: CGFloat = self.descTextView.frame.size.height
        let contentSize = self.descTextView.sizeThatFits(self.descTextView.bounds.size)

        diff = contentSize.height - diff

        self.descHeightConstraint.constant = self.descHeightConstraint.constant + diff
        self.layoutIfNeeded()

    }

    fileprivate func animateTitle() {
        self.animateScroll(withMultiplier: 0.5, withDuration: 0.0)
        self.animateScroll(withMultiplier: self.firstMultiplier)

        UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.subscribeButton.alpha = 1.0
            self.layoutIfNeeded()
        }, completion: nil)

        UIView.animate(withDuration: 0.8, delay: 0.5, animations: {
            self.descTextView.alpha = 1.0
            self.overviewLabel.alpha = 1.0
        })
    }

    fileprivate func animateScroll(withMultiplier: CGFloat, withDuration: TimeInterval = 0.5) {

        let constraint = self.titleViewYConstraint.constraintWithMultiplier(multiplier: withMultiplier)
        self.titleViewYConstraint.isActive = false
        self.titleViewYConstraint = constraint
        self.titleViewYConstraint.isActive = true
        self.addConstraint(constraint)


        UIView.animate(withDuration: withDuration, delay: 0.0, animations: {
            self.layoutIfNeeded()
        })

    }

    fileprivate func isRotated() -> Bool {
        let w = self.bounds.width
        let h = self.bounds.height

        return w > h
    }

    //MARK - IBAction

    @IBAction func goBack(_ sender: UIButton) {
        NotificationCenter.default.post(name:  Notification.Name("backButtonPressed"), object: nil)
    }
}

extension MATVShowDetailsView : UIScrollViewDelegate {


    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        userDidScroll = true
        if self.isRotated() {
            self.animateScroll(withMultiplier: self.shortScroll)
            return
        }

        self.animateScroll(withMultiplier: self.longScroll)
    }



}


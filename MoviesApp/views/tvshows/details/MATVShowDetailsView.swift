//
// Created by MIGUEL MOLDES on 20/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import UIKit
import ColorThiefSwift



class MATVShowDetailsView : UIView {

    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subscribeButton: MASubscribeButton!
    @IBOutlet weak var titleViewYConstraint: NSLayoutConstraint!
    
    
    var model : MATVShowDetailsViewModel! {
        didSet {
            self.bind()
            self.setup()
        }
    }

    func viewDidAppear() {

        self.animateThumbnail()

        self.animateTitle()

    }

    func viewWillLayoutSubviews() {
//        self.animateThumbnail()
//        self.animateTitle()

    }

    func viewDidLayoutSubviews() {
        self.animateThumbnail()
        self.animateTitle()
    }

    //MARK - Private

    fileprivate func bind() {

    }

    fileprivate func setup() {
        self.thumbnailView.layer.cornerRadius = 6.0
        self.thumbnailView.clipsToBounds = true
        self.thumbnailView.image = model.image
        self.thumbnailView.frame = model.imageRect

        self.backgroundImageView.alpha = 0.0
        self.backgroundImageView.image = model.backImage
        
        self.backgroundImageView.image = self.model.backImage?.tint(with: UIColor.black, blendMode: .color)
        
        self.bgView.backgroundColor = self.model.backgroundColor

        self.subscribeButton.alpha = 0.0
        self.setupLabels()

    }

    fileprivate func setupLabels() {

        var year: String = ""
        if let date = model.tvShow.airDate {
            year = "\(date.getYear())"
        }
        let str = model.tvShow.name + "\n" + year
        let attributed = NSMutableAttributedString(string: str)

        let spaceIndex = model.tvShow.name.characters.count

        let fontSize = self.titleLabel.font.pointSize

        attributed.addAttribute(NSFontAttributeName, value:UIFont(name: self.titleLabel.font.fontName, size: fontSize) as Any, range:NSMakeRange(0, spaceIndex))
        attributed.addAttribute(NSFontAttributeName, value:UIFont(name: "Helvetica", size: fontSize * 0.7) as Any, range:NSMakeRange(spaceIndex, year.characters.count + 1))

        self.titleLabel.attributedText = attributed

        self.titleView.alpha = 0.0
    }

    fileprivate func animateThumbnail() {

        let w = self.bounds.width
        let h = self.bounds.height

        if w > h {
            self.animateHorizontal()
            return
        }

        let finalWidth = w / 2
        let relation = self.model.imageRect.size.width / self.model.imageRect.size.height
        let finalHeight = finalWidth / relation

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.thumbnailView.frame.origin.x = w / 2 - finalWidth / 2
            self.thumbnailView.frame.origin.y = h * 0.27 - finalHeight / 2
            self.thumbnailView.frame.size.width = finalWidth
            self.thumbnailView.frame.size.height = finalHeight
            self.backgroundImageView.alpha = 0.1
            self.bgView.alpha = 1.0
        }, completion: nil)

    }

    fileprivate func animateHorizontal() {
        let w = self.bounds.width
        let h = self.bounds.height

        let finalHeight = h / 3
        let relation = self.model.imageRect.size.width / self.model.imageRect.size.height
        let finalWidth = finalHeight * relation

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.thumbnailView.frame.origin.x = w / 2 - finalWidth / 2
            self.thumbnailView.frame.origin.y = h * 0.27 - finalHeight / 2
            self.thumbnailView.frame.size.width = finalWidth
            self.thumbnailView.frame.size.height = finalHeight
            self.backgroundImageView.alpha = 0.1
            self.bgView.alpha = 1.0
        }, completion: nil)

    }

    fileprivate func animateTitle() {
        self.layoutIfNeeded()
        
        if let constraint = self.titleViewYConstraint, constraint.isActive {
            let newYConstraint = constraint.constraintWithMultiplier(multiplier: 1.09)
            self.titleViewYConstraint.isActive = false
            self.addConstraint(newYConstraint)
        }

        UIView.animate(withDuration: 0.4, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.titleView.alpha = 1.0
            self.subscribeButton.alpha = 1.0
            self.layoutIfNeeded()
        }, completion: nil)
    }

    //MARK - Private

    @IBAction func goBack(_ sender: UIButton) {
        NotificationCenter.default.post(name:  Notification.Name("backButtonPressed"), object: nil)
    }
}


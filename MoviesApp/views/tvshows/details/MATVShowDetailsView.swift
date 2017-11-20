//
// Created by MIGUEL MOLDES on 20/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import UIKit

class MATVShowDetailsView : UIView {

    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var model : MATVShowDetailsViewModel! {
        didSet {
            self.bind()
            self.setup()
        }
    }

    func viewDidAppear() {

        let finalWidth = self.frame.size.width / 2
        let relation = self.model.imageRect.size.width / self.model.imageRect.size.height
        let finalHeight = finalWidth / relation

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.thumbnailView.frame.origin.x = self.frame.size.width / 2 - finalWidth / 2
            self.thumbnailView.frame.origin.y = self.frame.size.height * 0.27 - finalHeight / 2
            self.thumbnailView.frame.size.width = finalWidth
            self.thumbnailView.frame.size.height = finalHeight
            self.backgroundImageView.alpha = 1.0
        }, completion: nil)

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
    }

    @IBAction func goBack(_ sender: UIButton) {
        NotificationCenter.default.post(name:  Notification.Name("backButtonPressed"), object: nil)
    }
}


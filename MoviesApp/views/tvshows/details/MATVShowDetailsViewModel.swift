//
// Created by MIGUEL MOLDES on 20/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import UIKit

class MATVShowDetailsViewModel {

    let tvShow: TVShow
    let image: UIImage
    let backImage: UIImage?
    let imageRect: CGRect

    init(tvShow: TVShow, image: UIImage, imageRect: CGRect, backImage: UIImage?) {
        self.tvShow = tvShow
        self.image = image
        self.backImage = backImage
        self.imageRect = imageRect
    }



}
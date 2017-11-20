//
// Created by MIGUEL MOLDES on 20/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import PromiseKit

class MAPrepareImagesForDetail {

    func prepare(tvShow: TVShow, rect: CGRect) -> Promise<Bool> {

        var posterImage: UIImage!
        var bgImage: UIImage?

        let posterPath = self.getFinalPosterPath(tvShow: tvShow)
        let backImagePath = self.getFinalBackImagePath(tvShow: tvShow)

        return Promise<Bool> {
            fulfill, reject in

            MALoadImageService(service: MAService()).execute(path: posterPath, size: 500).then {
                image -> Promise<UIImage?> in

                guard let image = image else {
                    return Promise<UIImage?>{
                        fulfill, reject in
                        reject(MAServiceError.noImage)
                    }
                }

                posterImage = image

                return MALoadImageService(service: MAService()).execute(path: backImagePath, size: 1280)
            }.then {
                image -> Promise<UIColor> in

                bgImage = image


                return self.getColorFromImage(image: posterImage)

            }.then {
                color -> Void in

                MAGlobalModels.sharedInstance.flowController.gotoDetails(tvShow: tvShow, image: posterImage, rect: rect, backgroundColor: color, backImage: bgImage)
                fulfill(true)

            }.catch(policy: .allErrors) {
                error in
                reject(error)
            }

        }

    }

    fileprivate func getColorFromImage(image: UIImage) -> Promise<UIColor> {
        return Promise<UIColor> {
            fulfill, reject in

            DispatchQueue.global(qos: .utility).async {
                fulfill(LEColorPicker().colorScheme(from: image)!.backgroundColor)
            }

        }

    }

    fileprivate func getFinalBackImagePath(tvShow: TVShow) -> String {
        var imagePath:String = MAServiceConfig.DEFAULT_BACK_IMAGE_PATH
        if let backPath = tvShow.backdropPath {
            imagePath = backPath
        }
        return imagePath
    }

    fileprivate func getFinalPosterPath(tvShow: TVShow) -> String {
        var imagePath:String = MAServiceConfig.DEFAULT_THUMB_PATH
        if let posterPath = tvShow.posterPath {
            imagePath = posterPath
        }
        return imagePath
    }

}
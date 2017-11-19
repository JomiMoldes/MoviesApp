//
// Created by MIGUEL MOLDES on 19/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit


class MALoadImageService : MALoadImageServiceProtocol{

    let service : MAServiceProtocol

    init(service: MAServiceProtocol) {
        self.service = service
    }

    func execute(path: String, size: Int) -> Promise<UIImage?> {
        return Promise<UIImage?> {
            fulfill, reject in

            let finalPath = self.service.config.createURLForImage(imageName: path, size: size)

            let request = MARequest(requestType: .get, path: finalPath)

            self.service.executeData(request, nil).then {
                response -> Void in

                if let image = UIImage(data: response) {
                    fulfill(image)
                    return
                }

                fulfill(nil)

            }.catch(policy:.allErrors) {
                error in
                reject(error)
            }
        }

    }



}

protocol MALoadImageServiceProtocol {

    func execute(path: String, size: Int) -> Promise<UIImage?>

}
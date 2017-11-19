//
// Created by MIGUEL MOLDES on 19/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import PromiseKit

class MAAssetsManager {

    fileprivate var cache = Dictionary<String, UIImage>()

    func loadImage(path: String, size: Int, service: MALoadImageServiceProtocol) -> Promise<UIImage?> {
        return Promise<UIImage?> {
            fulfill, reject in

            let key = path + "\(size)"

            if let imageCached = cache[key] {
                fulfill(imageCached)
                return
            }

            service.execute(path: path, size: size).then {
                image -> Void in

                guard let image = image else {
                    fulfill(nil)
                    return
                }
                self.cache[key] = image
                fulfill(image)
            }.catch(policy: .allErrors){
                error in
                reject(error)
            }

        }
    }

    func refresh() {
        cache = Dictionary<String, UIImage>()
    }

}
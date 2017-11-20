//
// Created by MIGUEL MOLDES on 20/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

class MAGenresService {

    func execute() -> Promise<Bool> {
        return Promise<Bool> {
            fulfill, reject in

            let service = MAService()

            let path = MAGlobalModels.sharedInstance.serviceConfig.createPathForJSON(for: "/3/genre/movie/list", items: [:])

            let request = MARequest(requestType: .get, path: path)

            service.execute(request, nil).then {
                response -> Void in

                guard let value = response.result.value as? [String: Any],
                      let list = value["genres"] as? [[String: Any]] else {
                    reject(MAServiceError.noJSON)
                    return
                }

                MAGlobalModels.sharedInstance.genresModel.fromJSON(list: list)
                fulfill(true)

            }.catch (policy: .allErrors) {
                error in
                reject(error)
            }

        }
    }

}

protocol MAGenresServiceProtocol {

    func execute() -> Promise<Bool>

}
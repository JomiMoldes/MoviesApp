//
// Created by MIGUEL MOLDES on 19/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit


class MAService : MAServiceProtocol {

    var config : MAServiceConfig

    init(config: MAServiceConfig) {
        self.config = config
    }

    func execute(_ request: MARequestProtocol,_ retry:Int?) -> Promise<DataResponse<Any>> {
        let operation = Promise<DataResponse<Any>> {
            fulfill, reject in
            let url : URLConvertible = URL(string:self.config.path + request.path)!
            Alamofire.request(url, method: request.method).responseJSON {
                response in

                if let error = response.error {
                    reject(error)
                    return
                }

                fulfill(response)

            }

        }

        return operation
    }

    func executeData(_ request: MARequestProtocol,_ retry:Int?) -> Promise<Data> {
        let operation = Promise<Data> {
            fulfill, reject in
            let url : URLConvertible = URL(string: request.path)!
            Alamofire.request(url, method: request.method).responseData {
                response in

                if let error = response.error {
                    reject(error)
                    return
                }

                if let data = response.data {
                    fulfill(data)
                    return
                }

                reject(MAServiceError.noData)

            }

        }

        return operation
    }

}

protocol MAServiceProtocol {

    var config : MAServiceConfig { get set }

    func execute(_ request: MARequestProtocol,_ retry:Int?) -> Promise<DataResponse<Any>>

    func executeData(_ request: MARequestProtocol,_ retry:Int?) -> Promise<Data>

}

enum MAServiceError : Error {
    case noJSON
    case noImage
    case noData

}
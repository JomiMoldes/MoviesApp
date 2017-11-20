//
//  MoviesService.swift
//  MoviesApp
//
//  Created by Matias Gualino on 7/19/17.
//  Copyright © 2017 Matias Gualino. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class MoviesService {
    
    static let BASE_URL : String = "https://api.themoviedb.org/"
    static let API_KEY : String = "208ca80d1e219453796a7f9792d16776"
    
    let service : MAServiceProtocol

    init(service: MAServiceProtocol) {
        self.service = service
    }

    func search(query: String) -> Promise<SearchResponse> {
        return Promise<SearchResponse> {
            fulfill, reject in

            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }

            let request = MARequest(requestType: .get, path: MAGlobalModels.sharedInstance.serviceConfig.createPathForJSON(for: MAServiceConfig.SEARCH_URI, items: ["query": query]))

            self.service.execute(request, nil).then {
                response -> Void in

                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }

                guard let value = response.result.value as? [String: Any] else {
                    reject(MAServiceError.noJSON)
                    return
                }

                guard let searchResponse = SearchResponse.fromJSON(json: value) else {
                    reject(MAServiceError.decodingMovies)
                    return
                }

                fulfill(searchResponse)

            }.catch(policy: .allErrors) {
                error in
                reject(error)
            }

        }
    }
    

}

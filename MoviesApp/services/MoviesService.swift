//
//  MoviesService.swift
//  MoviesApp
//
//  Created by Matias Gualino on 7/19/17.
//  Copyright © 2017 Matias Gualino. All rights reserved.
//

import Foundation
import UIKit

class MoviesService {
    
    static let BASE_URL : String = "https://api.themoviedb.org/"
    static let API_KEY : String = "208ca80d1e219453796a7f9792d16776"
    
    static let SEARCH_URI : String = "3/search/tv"
    
    static func search(query: String, success: @escaping ((SearchResponse) -> Void), failure: @escaping ((NSError) -> Void)) {
        guard let url = url(for: SEARCH_URI, key: API_KEY, items: ["query": query])
            else {
            return failure(NSError(domain: "Movies", code: -1, userInfo: ["message":"cannot read url"]))
        }

        self.request(url: url, success: {
            json in
            if let searchResponse = SearchResponse.fromJSON(json: json) {
                success(searchResponse)
            } else {
                failure(NSError(domain: "Movies", code: -2, userInfo: ["message":"cannot decode response"]))
            }
        }, failure: { error in
            failure(error)
        })
    }
    
    // TODO: GET Genre for TVShow
    
    private static func request(url: URL, success: @escaping (_ jsonResult: [String:Any]) -> Void, failure: ((_ error: NSError) -> Void)?) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let error = error {
                failure?(error as NSError)
            } else {
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        if let jsonDic = json as? [String: Any] {
                            success(jsonDic)
                        } else {
                            self.failureDecodeResponse(failure: failure)
                        }
                    } else {
                        self.failureDecodeResponse(failure: failure)
                    }
                } else {
                    self.failureDecodeResponse(failure: failure)
                }
            }
        }
        task.resume()
    }
    
    static func failureDecodeResponse(failure: ((_ error: NSError) -> Void)?) {
        let e: NSError = NSError(domain: "Movies", code: NSURLErrorCannotDecodeContentData, userInfo: nil)
        failure?(e)
    }
    
    private static func url(for path: String, key: String, items: [String: String] = [:]) -> URL? {
        
        var query = "?api_key=" + key
        items.forEach { query = query + "&" + $0 + "=" + $1 }
        let url = BASE_URL + path + query
        return URL(string: url)
    }
    
}

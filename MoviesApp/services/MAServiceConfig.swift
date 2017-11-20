//
// Created by MIGUEL MOLDES on 19/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation

struct MAServiceConfig : MAServiceConfigProtocol {

    static let BASE_URL : String = "https://api.themoviedb.org"
    static let API_KEY : String = "208ca80d1e219453796a7f9792d16776"
    static let IMAGE_BASE_URL : String = "https://image.tmdb.org"
    static let SEARCH_URI : String = "/3/search/tv"
    static let GENRES_LIST : String = "/3/genre/movie/list"

    static let DEFAULT_THUMB_PATH : String = "/1yeVJox3rjo2jBKrrihIMj7uoS9.jpg"
    static let DEFAULT_BACK_IMAGE_PATH : String = "/bzoZjhbpriBT2N5kwgK0weUfVOX.jpg"

    let path: String
    let key : String
    let imageBasePath : String

    init() {
        self.path = MAServiceConfig.BASE_URL
        self.key = MAServiceConfig.API_KEY
        self.imageBasePath = MAServiceConfig.IMAGE_BASE_URL
    }

    func createPathForJSON(for action: String, items: [String: String]) -> String {

        var query = "?api_key=" + self.key
        items.forEach { query = query + "&" + $0 + "=" + $1 }
        let url = self.path + action + query
        return url
    }

    func createPathForImage(imageName: String, size: Int) -> String {
        let path = self.imageBasePath + "/t/p/w\(size )\(imageName)"
        return path
    }


}

protocol MAServiceConfigProtocol  {

    func createPathForJSON(for action: String, items: [String: String]) -> String

    func createPathForImage(imageName: String, size: Int) -> String

}
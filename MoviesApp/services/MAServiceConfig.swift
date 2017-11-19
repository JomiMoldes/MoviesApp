//
// Created by MIGUEL MOLDES on 19/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation

struct MAServiceConfig {

    static let BASE_URL : String = "https://api.themoviedb.org"
    static let API_KEY : String = "208ca80d1e219453796a7f9792d16776"
    static let IMAGE_BASE_URL : String = "https://image.tmdb.org"

    let path: String
    let key : String
    let imageBasePath : String

    init() {
        self.path = MAServiceConfig.BASE_URL
        self.key = MAServiceConfig.API_KEY
        self.imageBasePath = MAServiceConfig.IMAGE_BASE_URL
    }

    func createUrl(for action: String, items: [String: String] = [:]) -> URL? {

        var query = "?api_key=" + self.key
        items.forEach { query = query + "&" + $0 + "=" + $1 }
        let url = self.path + action + query
        return URL(string: url)
    }

    func createURLForImage(imageName: String, size: Int) -> String {
        let path = self.imageBasePath + "/t/p/w\(size )\(imageName)"
        return path
    }


}
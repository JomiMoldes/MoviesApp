//
// Created by MIGUEL MOLDES on 20/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation

class MAGenresModel {

    var genres = [Int: String]()

    func fromJSON(list:[[String: Any]]) {
        var genres = [Int:String]()

        for genre in list {
            if let id = genre["id"] as? Int,
               let name = genre["name"] as? String {
                genres[id] = name
            }
        }

        self.genres = genres
    }

    func getGenreNameById(id: Int) -> String {
        if let name = genres[id] {
            return name
        }
        return ""
    }

}

protocol MAGenresModelProtocol  {

    var genres : [Int: String] { get set }

    func getGenreNameById(id: Int) -> String

}
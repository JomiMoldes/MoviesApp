//
//  TVShow.swift
//  MoviesApp
//
//  Created by Matias Gualino on 7/19/17.
//  Copyright © 2017 Matias Gualino. All rights reserved.
//

import Foundation

class TVShow {
    
    let id: Int
    let name: String
    let genres: [Int]
    let overview: String
    let airDate: Date?
    let posterPath: String?
    let backdropPath: String?
    
    init(id: Int, name: String, genres: [Int], overview: String, airDate: Date?, posterPath: String?, backdropPath: String?) {
        self.id = id
        self.name = name
        self.genres = genres
        self.overview = overview
        self.airDate = airDate
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }
    
    static func fromJSON(json: [String: Any]) -> TVShow? {
        guard let id = json["id"] as? Int,
            let genreIds = json["genre_ids"] as? [Int],
            let overview = json["overview"] as? String,
            let name = json["name"] as? String
            else { return nil }
        let posterPath = json["poster_path"] as? String
        let backdropPath = json["backdrop_path"] as? String
        let date: Date?
        if let airDate = json["first_air_date"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            date = formatter.date(from: airDate)
        } else {
            date = nil
        }
        return TVShow(id: id, name: name, genres: genreIds, overview: overview, airDate: date, posterPath: posterPath, backdropPath: backdropPath)
    }
}

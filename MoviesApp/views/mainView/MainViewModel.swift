//
// Created by MIGUEL MOLDES on 19/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import PromiseKit

class MainViewModel : NSObject {

    var tvShows = Variable<[TVShow]>([TVShow]())

    func setup() {

        let genresService = MAGenresService()
        let moviesService = MoviesService(service: MAService())

        genresService.execute().then {
            success in
            return moviesService.search(query: "breaking")
        }.then {
            searchResponse in

            self.tvShows.value = searchResponse.results

        }.catch(policy: .allErrors) {
            error in
            print(error)
        }
    }

    //MARK - Private

    fileprivate func loadImage(cell: TVShowCell, show: TVShow) {
        let generation = cell.generation
        let service = MALoadImageService(service: MAService())

        var defaultImage = true
        var imagePath:String = MAServiceConfig.DEFAULT_THUMB_PATH
        if let posterPath = show.posterPath {
            defaultImage = false
            imagePath = posterPath
        }

        MAGlobalModels.sharedInstance.assetsManager.loadImage(path: imagePath, size: 92, service: service).then {
            image -> Void in

            guard let icon = cell.thumbImageView,
                  cell.generation == generation else {
                return
            }
            
            DispatchQueue.main.async {
                guard let image = image else {
                    icon.image = nil
                    return
                }
                icon.alpha = defaultImage ? 0.1 : 1
                icon.image = image
            }
        }.catch(policy: .allErrors) {
            error in
            print (error.localizedDescription)
        }
    }

    fileprivate func getGenresNames(tvShow: TVShow) -> String {
        var names = ""
        var first = true
        for id in tvShow.genres {
            let genreName = MAGlobalModels.sharedInstance.genresModel.getGenreNameById(id: id)
            guard genreName != "" else {
                continue
            }
            if first == false {
                names += " / "
            }
            names += genreName
            first = false
        }
        return names
    }

    fileprivate func showSelected(tvShow: TVShow, rect: CGRect) {

        var posterImage: UIImage!

        let posterPath = self.getFinalPosterPath(tvShow: tvShow)
        let backImagePath = self.getFinalBackImagePath(tvShow: tvShow)

        MALoadImageService(service: MAService()).execute(path: posterPath, size: 500).then {
            image -> Promise<UIImage?> in

            guard let image = image else {
                return Promise<UIImage?>{
                    fulfill, reject in
                    reject(MAServiceError.noImage)
                }
            }

            posterImage = image

            return MALoadImageService(service: MAService()).execute(path: backImagePath, size: 1280)
        }.then {
            image -> Void in

            MAGlobalModels.sharedInstance.flowController.gotoDetails(tvShow: tvShow, image: posterImage, rect: rect, backImage: image)
            
        }.catch(policy: .allErrors) {
            error in
            print(error)
        }

    }
    fileprivate func getFinalBackImagePath(tvShow: TVShow) -> String {
        var defaultImage = true
        var imagePath:String = MAServiceConfig.DEFAULT_BACK_IMAGE_PATH
        if let backPath = tvShow.backdropPath {
            defaultImage = false
            imagePath = backPath
        }
        return imagePath
    }

    fileprivate func getFinalPosterPath(tvShow: TVShow) -> String {
        var defaultImage = true
        var imagePath:String = MAServiceConfig.DEFAULT_THUMB_PATH
        if let posterPath = tvShow.posterPath {
            defaultImage = false
            imagePath = posterPath
        }
        return imagePath
    }

}

extension MainViewModel : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TVShowCell {
            if let view = tableView.superview {
                let pos = cell.convert(cell.thumbImageView.frame.origin, to: nil)
                let rect = CGRect(origin: pos, size: cell.thumbImageView.frame.size)
                self.showSelected(tvShow: cell.tvShow, rect: rect)
            }
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
//            cell.contentView.backgroundColor = UIColor.white
        }
    }

}

extension MainViewModel : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tvShows.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TVShowCell!

        let tvShowSelected = self.tvShows.value[(indexPath as NSIndexPath).item]
        cell = tableView.dequeueReusableCell(withIdentifier: "TVShowCell", for: indexPath) as! TVShowCell

        cell.selectionStyle = .none

        let tvShow = tvShowSelected as! TVShow
        let genreName = self.getGenresNames(tvShow: tvShow)

        cell.fill(with: tvShow, genreNames: genreName.uppercased())
        cell.backgroundColor = UIColor.clear

        self.loadImage(cell: cell as! TVShowCell, show: tvShowSelected)

        return cell
    }

}
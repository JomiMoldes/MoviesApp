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

    var activityIndicator = PublishSubject<Bool>()

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

        activityIndicator.onNext(true)

        MAPrepareImagesForDetail().prepare(tvShow: tvShow, rect: rect).then {
            success in

            self.activityIndicator.onNext(false)
        }.catch(policy: .allErrors) {
            error in
            self.activityIndicator.onNext(false)
        }

    }

}

extension MainViewModel : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TVShowCell {
            let pos = cell.convert(cell.thumbImageView.frame.origin, to: nil)
            let rect = CGRect(origin: pos, size: cell.thumbImageView.frame.size)
            self.showSelected(tvShow: cell.tvShow, rect: rect)
        }
    }

}

extension MainViewModel : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tvShows.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TVShowCell!

        let tvShow = self.tvShows.value[(indexPath as NSIndexPath).item]
        cell = tableView.dequeueReusableCell(withIdentifier: "TVShowCell", for: indexPath) as! TVShowCell

        cell.selectionStyle = .none

        let genreName = self.getGenresNames(tvShow: tvShow)

        cell.fill(with: tvShow, genreNames: genreName.uppercased())
        cell.backgroundColor = UIColor.clear

        self.loadImage(cell: cell, show: tvShow)

        return cell
    }

}
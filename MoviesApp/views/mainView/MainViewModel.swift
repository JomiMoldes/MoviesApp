//
// Created by MIGUEL MOLDES on 19/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MainViewModel : NSObject {

    var tvShows = Variable<[TVShow]>([TVShow]())

    func setup() {
        MoviesService.search(query: "breaking", success: {
            searchResponse in
            
            self.tvShows.value = searchResponse.results

        }, failure: { error in
            print(error)
        })
    }

    fileprivate func loadImage(cell: TVShowCell, show: TVShow) {
        let generation = cell.generation
        let service = MALoadImageService(service: MAService(config: MAGlobalModels.sharedInstance.serviceConfig))

        var defaultImage = true
        var imagePath:String = "/1yeVJox3rjo2jBKrrihIMj7uoS9.jpg"
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

}

extension MainViewModel : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TVShowCell {
//            cell.backgroundColor = UIColor.clear
//            cell.contentView.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.3)
//            self.selectedRow(installment: installment)
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

        cell.fill(with: tvShowSelected as! TVShow)
        cell.backgroundColor = UIColor.clear

        self.loadImage(cell: cell as! TVShowCell, show: tvShowSelected)

//        let backgroundView = UIView()
//        backgroundView.backgroundColor = UIColor.blue
//        cell.selectedBackgroundView = backgroundView


        return cell
    }

}
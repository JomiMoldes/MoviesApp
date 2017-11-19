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

//        let backgroundView = UIView()
//        backgroundView.backgroundColor = UIColor.blue
//        cell.selectedBackgroundView = backgroundView

        return cell
    }

}
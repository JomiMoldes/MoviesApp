//
//  TVShowCell.swift
//  MoviesApp
//
//  Created by Matias Gualino on 7/19/17.
//  Copyright © 2017 Matias Gualino. All rights reserved.
//

import Foundation
import UIKit

class TVShowCell : UITableViewCell {
    
    // TODO: Implement
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    func fill(with: TVShow) {
        self.titleLabel.text = with.name
        
    }
    
}

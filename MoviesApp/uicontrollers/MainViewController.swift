//
//  ViewController.swift
//  MoviesApp
//
//  Created by Matias Gualino on 7/19/17.
//  Copyright © 2017 Matias Gualino. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    var customView : MainView! {
        get {
            return view as! MainView
        }
    }
    

    var searchController: UISearchController? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


}

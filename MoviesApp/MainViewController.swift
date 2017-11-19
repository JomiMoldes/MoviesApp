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
    
    var tvShowsCollectionView: UICollectionView!
    var searchController: UISearchController? = nil
    
    var tvShows : [TVShow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movies App"
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
        collectionView.register(TVShowCell.classForCoder(), forCellWithReuseIdentifier: "TVShowCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        
        self.tvShowsCollectionView = collectionView
        
        MoviesService.search(query: "breaking", success: { searchResponse in
            
            for i in searchResponse.results {
                print(i.name)
            }
            
        }, failure: { error in
            print(error)
        })
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVShowCell", for: indexPath) as! TVShowCell
        cell.fill(with: self.tvShows[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tvShows.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: 156)
    }
    
}

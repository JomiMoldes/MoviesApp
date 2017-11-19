//
// Created by MIGUEL MOLDES on 19/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MainView : UIView {
    
    var model : MainViewModel! {
        didSet {
            self.bind()
            self.setup()
        }
    }

    var tvShowsCollectionView: UICollectionView!

    fileprivate func bind() {

    }

    fileprivate func setup() {
        self.setupCollectionView()
    }

    fileprivate func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        collectionView.register(TVShowCell.classForCoder(), forCellWithReuseIdentifier: "TVShowCell")
        collectionView.dataSource = model
        collectionView.delegate = model
        collectionView.backgroundColor = UIColor.clear

        self.tvShowsCollectionView = collectionView
    }
    

}

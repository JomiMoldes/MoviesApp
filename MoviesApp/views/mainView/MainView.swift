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

    var activityIndicator : UIActivityIndicatorView?

    fileprivate var tvShowsTableView : UITableView!

    private let disposeBag = DisposeBag()

    fileprivate func bind() {
        
        self.model.tvShows.asObservable().subscribe(onNext: {
            [unowned self] values in
            DispatchQueue.main.async {
                self.tvShowsTableView.reloadData()
            }
        }).disposed(by: self.disposeBag)

        self.model.activityIndicator.asObservable().subscribe(onNext: {
            [unowned self] show in
            DispatchQueue.main.async {
                self.showActivityIndicator(show: show)
            }
        }).disposed(by: self.disposeBag)

    }

    fileprivate func showActivityIndicator(show: Bool) {
        if self.activityIndicator == nil {
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            self.addSubview(self.activityIndicator!)
        }

        guard let indicator = self.activityIndicator else {
            return 
        }

        indicator.isHidden = show ? false : true
        guard show == true else {
            indicator.stopAnimating()
            return
        }

        indicator.center = self.center
        indicator.hidesWhenStopped = false
        indicator.startAnimating()
    }

    fileprivate func setup() {
        self.setupTable()

        self.model.setup()
    }

    fileprivate func setupTable() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        tableView.rowHeight = 92.0
        tableView.register(UINib(nibName: "TVShowCellView", bundle: nil), forCellReuseIdentifier: "TVShowCell")
        tableView.dataSource = model
        tableView.delegate = model
        tableView.backgroundColor = UIColor.clear

        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none

        self.tvShowsTableView = tableView
    }
    

}

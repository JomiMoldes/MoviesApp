//
// Created by MIGUEL MOLDES on 20/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import UIKit

class MATVShowDetailsViewController : UIViewController {

    
    var customView : MATVShowDetailsView! {
        get {
            return self.view as! MATVShowDetailsView
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customView.viewDidAppear()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        customView.viewDidLayoutSubviews()
    }
}

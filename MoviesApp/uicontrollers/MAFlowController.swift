//
// Created by MIGUEL MOLDES on 20/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import UIKit

class MAFlowController : MAFlowControllerProtocol {

    var navController : UINavigationController!
//    var initialVC : UIViewController?

    var currentVCName : String = ""

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(goBack(notification:)), name: Notification.Name("backButtonPressed"), object: nil)
    }

    func addFirstView() {
        self.navController = UINavigationController(rootViewController: self.createInitialVC())
    }

    func gotoDetails(tvShow: TVShow, image: UIImage, rect: CGRect, backImage: UIImage?) {
        let vc = MATVShowDetailsViewController(nibName: "MATVShowDetailsView", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext

        vc.customView.model = MATVShowDetailsViewModel(tvShow: tvShow, image: image, imageRect: rect, backImage: backImage)
        self.navController.present(vc, animated: false)
    }

    @objc func goBack(notification: Notification) {
        self.navController.dismiss(animated: false)
    }

    private func createInitialVC() -> MainViewController {
        let vc = MainViewController(nibName: "MainView", bundle: nil)
        vc.customView.model = MainViewModel()

//        self.initialVC = initialViewController
        return vc
    }

}

enum FlowView : String {
    case mainView
    case detailsView
}

protocol MAFlowControllerProtocol : class {


}

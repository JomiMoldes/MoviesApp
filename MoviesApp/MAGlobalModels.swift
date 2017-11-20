//
// Created by MIGUEL MOLDES on 19/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation

class MAGlobalModels {

    static let sharedInstance = MAGlobalModels()

    let assetsManager : MAAssetsManager
    let serviceConfig : MAServiceConfigProtocol
    let genresModel : MAGenresModel

    private init() {
        self.assetsManager = MAAssetsManager()
        self.serviceConfig = MAServiceConfig()
        self.genresModel = MAGenresModel()
    }

}
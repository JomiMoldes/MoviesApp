//
// Created by MIGUEL MOLDES on 20/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation

extension Date {

    func getYear() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }

}
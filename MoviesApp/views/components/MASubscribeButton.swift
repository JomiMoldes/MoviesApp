//
// Created by MIGUEL MOLDES on 20/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

import Foundation
import UIKit

class MASubscribeButton : UIButton {



    override func draw(_ rect: CoreGraphics.CGRect) {
        super.draw(rect)

        var bezier:UIBezierPath
        let newHeight = rect.height

        let newRect = CGRect(x:rect.origin.x + 1, y: rect.origin.y + 1, width: rect.size.width - 2, height:rect.size.height - 2)

        let roundSize = CGSize(width:newHeight / 2, height:newHeight / 2)
        bezier = UIBezierPath(roundedRect: newRect, byRoundingCorners: [.topLeft, .bottomLeft, .topRight, .bottomRight], cornerRadii: roundSize)


        let borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        borderColor.setStroke()
        bezier.lineWidth = 2.0
        bezier.stroke()
    }

}

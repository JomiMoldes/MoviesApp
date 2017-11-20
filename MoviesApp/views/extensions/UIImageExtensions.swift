//
// Created by MIGUEL MOLDES on 20/11/17.
// Copyright (c) 2017 Matias Gualino. All rights reserved.
//

extension UIImage {

    func tint(with color: UIColor, blendMode: CGBlendMode) -> UIImage  {

        defer {
            UIGraphicsEndImageContext()
        }

        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)

        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }

        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -self.size.height)

        context.setBlendMode(blendMode)

        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect)

        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }

        return newImage
    }
}


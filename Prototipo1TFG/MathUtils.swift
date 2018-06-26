//
//  MathUtils.swift
//  Prototipo1TFG
//
//  Created by Arancha Ferrero Ortiz de Zárate on 26/6/18.
//  Copyright © 2018 Arancha Ferrero Ortiz de Zárate. All rights reserved.
//

import Foundation
import CoreGraphics

func + (firstPoint: CGPoint, secondPoint: CGPoint) -> CGPoint {
    return CGPoint(x: firstPoint.x + secondPoint.x, y: firstPoint.y + secondPoint.y)
}

func += (firstPoint: inout CGPoint, secondPoint: CGPoint) {
    firstPoint = firstPoint + secondPoint
}

func - (firstPoint: CGPoint, secondPoint: CGPoint) -> CGPoint {
    return CGPoint(x: firstPoint.x - secondPoint.x, y: firstPoint.y - secondPoint.y)
}

func -= (firstPoint: inout CGPoint, secondPoint: CGPoint) {
    firstPoint = firstPoint - secondPoint
}

func * (firstPoint: CGPoint, secondPoint: CGPoint) -> CGPoint {
    return CGPoint(x: firstPoint.x * secondPoint.x, y: firstPoint.y * secondPoint.y)
}

func *= (firstPoint: inout CGPoint, secondPoint: CGPoint) {
    firstPoint = firstPoint * secondPoint
}

func * (firstPoint: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: firstPoint.x * scalar, y: firstPoint.y * scalar)
}

func *= (firstPoint: inout CGPoint, scalar: CGFloat) {
    firstPoint = firstPoint * scalar
}

func / (firstPoint: CGPoint, secondPoint: CGPoint) -> CGPoint {
    return CGPoint(x: firstPoint.x / secondPoint.x, y: firstPoint.y / secondPoint.y)
}

func /= (firstPoint: inout CGPoint, secondPoint: CGPoint) {
    firstPoint = firstPoint / secondPoint
}

func / (firstPoint: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: firstPoint.x / scalar, y: firstPoint.y / scalar)
}

func /= (firstPoint: inout CGPoint, scalar: CGFloat) {
    firstPoint = firstPoint / scalar
}

// Solo se ejecuta si la app corre en 32 bits
#if !(arch(x86_64) || arch(arm64))
    func atan2(y: CGFloat, x: CGFloat) -> CGFloat {
        return CGFloat(atan2f(Float(y), Float(x)))
    }

    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }

#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x+y*y)
    }
    
    func normalize() -> CGPoint {
        return self / length()
    }
    
    var angle : CGFloat {
        return atan2(y,x)
    }
}


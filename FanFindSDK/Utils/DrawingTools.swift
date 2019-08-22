//
//  DrawingTools.swift
//  LE
//
//  Created by Christopher Woolum on 12/20/18.
//  Copyright © 2018 locateeveryone. All rights reserved.
//

import Foundation
import MapKit

internal class DrawingTools {
    static func setupGradientLayer(unspecifiedCount: Int64, isSelected: Bool, showClusteredMarker: Bool = false) -> UIImage {
        let diameter = showClusteredMarker ? 50 : 40
        
        return drawRatio(0, to: Int(unspecifiedCount), fractionColor: UIColor.lightGray, wholeColor: UIColor.lightGray, diameter: diameter, count: Int(unspecifiedCount), isSelected: isSelected)
        
    }
    
    static func drawRatio(_ fraction: Int, to whole: Int, fractionColor: UIColor?, wholeColor: UIColor?, diameter: Int = 40, count: Int = 0, isSelected: Bool) -> UIImage {
        
        let primaryColorAdjusted = wholeColor
        let secondaryColorAdjusted = fractionColor
        var whiteColorAdjusted = UIColor.white
        let drarkGrayColorAdjusted = UIColor.darkGray
        var blackColorAdjusted = UIColor.black
        
        if isSelected {
            whiteColorAdjusted = FanFindConfiguration.primaryColor
            blackColorAdjusted = FanFindConfiguration.secondaryColor
            
        }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: diameter + 4, height: diameter + 4))
        return renderer.image { _ in
            // Fill full circle with wholeColor
            let primaryPath = UIBezierPath()
            let primaryEndAngle = (CGFloat.pi * 2.0 * CGFloat(whole - fraction)) / CGFloat(whole)
            primaryPath.addArc(withCenter: CGPoint(x: (diameter / 2) + 2, y: (diameter / 2) + 2), radius: CGFloat(diameter / 2) + 1,
                               startAngle: 0, endAngle: primaryEndAngle,
                               clockwise: true)
            primaryPath.lineWidth = 2
            primaryColorAdjusted?.setStroke()
            primaryPath.stroke()
            
            // Fill pie with fractionColor
            let secondaryPath = UIBezierPath()
            let secondaryEndAngle = (CGFloat.pi * 2.0 * CGFloat(fraction)) / CGFloat(whole) + primaryEndAngle
            secondaryPath.addArc(withCenter: CGPoint(x: (diameter / 2) + 2, y: (diameter / 2) + 2), radius: CGFloat(diameter / 2) + 1,
                                 startAngle: primaryEndAngle, endAngle: secondaryEndAngle,
                                 clockwise: true)
            
            secondaryPath.lineWidth = 2
            secondaryColorAdjusted?.setStroke()
            secondaryPath.stroke()
            
           
            
            // Fill inner circle with white color
            whiteColorAdjusted.setFill()
            UIBezierPath(ovalIn: CGRect(x: 3, y: 3, width: diameter - 2, height: diameter - 2)).fill()
            
            let borderPath = UIBezierPath()
            borderPath.addArc(withCenter: CGPoint(x: (diameter / 2) + 2, y: (diameter / 2) + 2),
                              radius: CGFloat(diameter / 2),
                              startAngle: 0, endAngle: CGFloat.pi * 2.0,
                              clockwise: true)
            borderPath.lineWidth = 0.5
            drarkGrayColorAdjusted.setStroke()
            borderPath.stroke()
            
            // Finally draw count text vertically and horizontally centered
            let attributes = [NSAttributedString.Key.foregroundColor: blackColorAdjusted,
                              NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
            
            let text = NumberAbbreviator().formatPoints(num: Double(count))
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: CGFloat(diameter / 2) + 1.5 - size.width / 2, y: CGFloat(diameter / 2) + 1.5 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
    
    static func drawSponsoredPlace(wholeColor: UIColor?, diameter: Int = 60, isSelected: Bool, count: Int = 0) -> UIImage {
        
        var blackColorAdjusted = UIColor.black
        var whiteColorAdjusted = UIColor.white
        let drarkGrayColorAdjusted = UIColor.darkGray
        
        if isSelected {
            whiteColorAdjusted = FanFindConfiguration.primaryColor
            blackColorAdjusted = FanFindConfiguration.secondaryColor
        }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: diameter + 4, height: diameter + 44))
        return renderer.image { ctx in
            
            // Draw the rectangle first
            let rectangle = CGRect(x: ((diameter-42)/2) + 2, y: 0, width: 42, height: 40)
            
            ctx.cgContext.setFillColor(whiteColorAdjusted.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.lightGray.cgColor)
            ctx.cgContext.setLineWidth(0.5)
            
            let roundRect = UIBezierPath(roundedRect: rectangle, byRoundingCorners:.allCorners, cornerRadii: CGSize(width: 4, height: 4))
            
            ctx.cgContext.addPath(roundRect.cgPath)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            ctx.cgContext.setShadow(offset: .zero, blur: 1, color: drarkGrayColorAdjusted.cgColor)
            
            // Fill inner circle with white color
            let circle = UIBezierPath(ovalIn: CGRect(x: 3, y: 20, width: diameter - 2, height: diameter - 2))
            circle.lineWidth = 0
            UIColor.white.setFill()
            circle.fill()
            circle.stroke()
            
            let attributes = [NSAttributedString.Key.foregroundColor: blackColorAdjusted,
                              NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
            
            let text = NumberAbbreviator().formatPoints(num: Double(count))
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: CGFloat(diameter / 2) + 1.5 - size.width / 2, y: 0, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}

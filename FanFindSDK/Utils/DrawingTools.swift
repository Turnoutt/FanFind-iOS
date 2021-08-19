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
        var whiteColorAdjusted = UIColor.white
        let drarkGrayColorAdjusted = UIColor.darkGray
        var blackColorAdjusted = UIColor.black
        
        if isSelected {
            whiteColorAdjusted = FanFindConfiguration.primaryColor
            blackColorAdjusted = FanFindConfiguration.secondaryColor
            
        }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: diameter + 4, height: diameter + 4))
        return renderer.image { ctx in
            // Fill full circle with wholeColor
            let primaryPath = UIBezierPath()
            let primaryEndAngle = (CGFloat.pi * 2.0 * CGFloat(whole - fraction)) / CGFloat(whole)
            primaryPath.addArc(withCenter: CGPoint(x: (diameter / 2) + 2, y: (diameter / 2) + 2), radius: CGFloat(diameter / 2) + 1,
                               startAngle: 0, endAngle: primaryEndAngle,
                               clockwise: true)
            primaryPath.lineWidth = 2
            primaryColorAdjusted?.setStroke()
            primaryPath.stroke()
            
            // Fill inner circle with white color
            whiteColorAdjusted.setFill()
            UIBezierPath(ovalIn: CGRect(x: 3, y: 3, width: diameter - 2, height: diameter - 2)).fill()
            
            let borderPath = UIBezierPath()
            borderPath.addArc(withCenter: CGPoint(x: (diameter / 2) + 2, y: (diameter / 2) + 2),
                              radius: CGFloat(diameter / 2) - 2,
                              startAngle: 0, endAngle: CGFloat.pi * 2.0,
                              clockwise: true)
            borderPath.lineWidth = 0.5
            primaryColorAdjusted!.setStroke()
            borderPath.stroke()
            
            ctx.cgContext.setShadow(offset: .init(width: 0, height: 1), blur: 1, color: drarkGrayColorAdjusted.cgColor)
            
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
            
            ctx.cgContext.setShadow(offset: .init(width: 0, height: 1), blur: 1, color: drarkGrayColorAdjusted.cgColor)
            
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
    
    static func drawNewBadge(wholeColor: UIColor?, diameter: Int = 30, isSelected: Bool, count: Int = 0) -> UIImage {
        
       
        var primaryColorAdjusted = UIColor.init(hexString: "818181")!
        var circleColor = UIColor.white
        
        if FanFindConfiguration.currentTheme == .Dark {
            primaryColorAdjusted = UIColor.init(hexString: "1f2326")!
            circleColor = UIColor.init(hexString: "434343")!
        }
        
        if isSelected {
            primaryColorAdjusted = FanFindConfiguration.primaryColor
        }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: diameter + 4, height: diameter + 44))
        return renderer.image { ctx in
            
            // Draw the rectangle first
            let rectangle = CGRect(x: 0, y: 0, width: diameter, height: 32)
            
            
            ctx.cgContext.setFillColor(primaryColorAdjusted.cgColor)
            ctx.cgContext.setStrokeColor(primaryColorAdjusted.cgColor)
            ctx.cgContext.setLineWidth(0.5)
            
            let roundRect = UIBezierPath(roundedRect: rectangle, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8, height: 8))
            
            ctx.cgContext.addPath(roundRect.cgPath)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            // Fill inner circle with white color
            let circle = UIBezierPath(ovalIn: CGRect(x: 1, y: 16, width: diameter - 2, height: diameter - 2))
            circle.lineWidth = 0
            circleColor.setFill()
            circle.fill()
            UIColor.init(hexString: "3c3c3c")!.setStroke()
            circle.lineWidth = 1
            circle.stroke()
            
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                              NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
            
            let text = NumberAbbreviator().formatPoints(num: Double(count))
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: CGFloat(diameter / 2) - size.width / 2, y: 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}

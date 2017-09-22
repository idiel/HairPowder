//
//  HairPowder.swift
//  iphonex
//
//  Created by Leonard on 2017. 9. 20..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit

open class HairPowder {
    static let instance = HairPowder()
    
    var hairStyle: HairStyle = .default
    
    public enum HairStyle {
        case `default`
        case boxCut
        
        func styledHairView(frame: CGRect) -> UIView {
            switch self {
            case .default:
                let powderView = HairPowderView(frame: frame)
                powderView.backgroundColor = UIColor.clear
                powderView.clipsToBounds = true
                return powderView
            case .boxCut:
                let powderView = BoxCutView(frame: frame)
                powderView.backgroundColor = UIColor.clear
                powderView.clipsToBounds = true
                return powderView
        }
    }
    
    private class BoxCutView: UIView {
        static let cornerY: CGFloat = 35
        override func draw(_ rect: CGRect)
        {
            let width = frame.width > frame.height ? frame.height : frame.width
            
            let rectPath = UIBezierPath()
            rectPath.move(to: CGPoint(x:0, y:0))
            rectPath.addLine(to: CGPoint(x: width, y: 0))
            rectPath.addLine(to: CGPoint(x: width, y: BoxCutView.cornerY))
            rectPath.addLine(to: CGPoint(x: 0, y: BoxCutView.cornerY))
            rectPath.close()
            rectPath.fill()
        }
    }
    
    private class HairPowderView: UIView {
        static let cornerRadius: CGFloat = 40
        static let cornerY: CGFloat = 35
        override func draw(_ rect: CGRect)
        {
            let width = frame.width > frame.height ? frame.height : frame.width
            
            let rectPath = UIBezierPath()
            rectPath.move(to: CGPoint(x:0, y:0))
            rectPath.addLine(to: CGPoint(x: width, y: 0))
            rectPath.addLine(to: CGPoint(x: width, y: HairPowderView.cornerY))
            rectPath.addLine(to: CGPoint(x: 0, y: HairPowderView.cornerY))
            rectPath.close()
            rectPath.fill()
            
            let leftCornerPath = UIBezierPath()
            leftCornerPath.move(to: CGPoint(x: 0, y: HairPowderView.cornerY + HairPowderView.cornerRadius))
            leftCornerPath.addLine(to: CGPoint(x: 0, y: HairPowderView.cornerY))
            leftCornerPath.addLine(to: CGPoint(x: HairPowderView.cornerRadius, y: HairPowderView.cornerY))
            leftCornerPath.addQuadCurve(to:  CGPoint(x: 0, y: HairPowderView.cornerY+HairPowderView.cornerRadius), controlPoint: CGPoint(x: 0, y: HairPowderView.cornerY))
            leftCornerPath.close()
            leftCornerPath.fill()
            
            let rightCornerPath = UIBezierPath()
            rightCornerPath.move(to: CGPoint(x: width, y: HairPowderView.cornerY+HairPowderView.cornerRadius))
            rightCornerPath.addLine(to: CGPoint(x: width, y: HairPowderView.cornerY))
            rightCornerPath.addLine(to: CGPoint(x: width-HairPowderView.cornerRadius, y: HairPowderView.cornerY))
            rightCornerPath.addQuadCurve(to:  CGPoint(x: width, y: 35+HairPowderView.cornerRadius), controlPoint: CGPoint(x: width, y: HairPowderView.cornerY))
            rightCornerPath.close()
            rightCornerPath.fill()
        }
    }
    
    private var statusWindow: UIWindow?
    
    private func powderedWindow() -> UIWindow {
        if let existingWindow = self.statusWindow { return existingWindow }
        
        let width: CGFloat = window?.frame.width ?? 0
        let height: CGFloat = window?.frame.height ?? 0
        
        let statusWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        statusWindow.windowLevel = UIWindowLevelStatusBar - 1
        
        let hairView = hairStyle.styledHairView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        statusWindow.addSubview(hairView)
        
        self.statusWindow = statusWindow
        
        return statusWindow
    }
    
    var window: UIWindow? {
        if let window = UIApplication.shared.keyWindow {
            return window
        } else if let window = UIApplication.shared.windows.first {
            return window
        }
        return nil
    }
    
    public func spread() {
        guard let window = window else { return }
        if #available(iOS 11.0, *) {
            if window.safeAreaInsets.top > 0.0 {
                DispatchQueue.main.async { [weak self] in
                    self?.powderedWindow().makeKeyAndVisible()
                    DispatchQueue.main.async { [weak self] in
                        window.makeKey()
                    }
                }
            }
        }
    }
}

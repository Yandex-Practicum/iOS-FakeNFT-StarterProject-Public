//
//  CustomAnimatedView.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 27.06.2023.
//

import UIKit

class CustomAnimatedView: UIView {
    
    private var shapeLayer: CAShapeLayer?
    
    var result: RequestResult? {
        didSet {
            guard let result else { return }
            createLayer(for: result)
        }
    }
    
    func startAnimation() {
        guard let shapeLayer = shapeLayer, let result else { return }
        layer.addSublayer(shapeLayer)
        createAnimationLayer(for: shapeLayer, with: result)
    }
    
    func stopAnimation() {
        removeTheLayer()
    }
}

// MARK: - Ext UIView creation
private extension CustomAnimatedView {
    func createLayer(for result: RequestResult) {
        shapeLayer = createShapeLayer(from: result)
    }
    
    func removeTheLayer() {
        shapeLayer?.removeFromSuperlayer()
        shapeLayer = nil
    }
    
    func createShapeLayer(from result: RequestResult) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = createCGPath(for: result)
        layer.strokeColor = UIColor.ypBlack?.cgColor
        layer.lineWidth = 5.0
        layer.fillColor = UIColor.clear.cgColor
        
        result == .loading ? layer.strokeEnd = 0.0 : ()  // Initially hide the circle
        
        return layer
    }
    
    func createCGPath(for result: RequestResult) -> CGPath {
        let size = createSize()
        
        switch result {
        case .success:
            return createCheckMarkPath(with: size)
        case .failure:
            return createXMarkPath(with: size)
        case .loading:
            return createCirclePath(with: size)
        }
    }
}

// MARK: - Ext Animation layer
private extension CustomAnimatedView {
    func createAnimationLayer(for layer: CAShapeLayer, with result: RequestResult) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.9
        
        if result == .loading { animation.repeatCount = .infinity }
        
        layer.add(animation, forKey: "strokeAnimation")
        
    }
}

// MARK: - Ext CGPAths
private extension CustomAnimatedView {
    func createSize() -> CGSize {
        CGSize(width: bounds.width, height: bounds.height)
    }
    
    func createCheckMarkPath(with size: CGSize) -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: size.width * 0.2, y: size.height * 0.5))
        path.addLine(to: CGPoint(x: size.width * 0.45, y: size.height * 0.75))
        path.addLine(to: CGPoint(x: size.width * 0.8, y: size.height * 0.25))
        return path.cgPath
    }
    
    func createXMarkPath(with size: CGSize) -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.width * 0.2, y: bounds.height * 0.2))
        path.addLine(to: CGPoint(x: bounds.width * 0.8, y: bounds.height * 0.8))
        path.move(to: CGPoint(x: bounds.width * 0.2, y: bounds.height * 0.8))
        path.addLine(to: CGPoint(x: bounds.width * 0.8, y: bounds.height * 0.2))
        return path.cgPath
    }
    
    func createCirclePath(with size: CGSize) -> CGPath {
        return UIBezierPath(ovalIn: bounds).cgPath
    }
}

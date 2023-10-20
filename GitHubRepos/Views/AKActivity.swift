//
//  AKActivity.swift
//

import UIKit

final class AKActivity: UIView {
    
    let showCircleIndicator: Bool  = true
    let indicatorSize: CGFloat     = 36
    let indicatorColor: UIColor    = .lightGray
    let bgColor: UIColor           = .white
    
    private static var activity: AKActivity? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func add(to view: UIView) {
        if activity != nil { return }
        let targetView = AKActivity.view(for: view) ?? view
        activity = AKActivity(frame: targetView.frame)
        activity?.backgroundColor = targetView.backgroundColor
        if let act = activity {
            view.addSubview(act)
        }
    }
    
    class func remove() {
        guard activity != nil else { return }
        activity?.removeFromSuperview()
        activity = nil
    }
    
    class func remove(_ animated: Bool) {
        guard activity != nil else { return }
        if animated {
            activity?.animateRemove()
        } else {
            AKActivity.remove()
        }
    }
    
    private func animateRemove() {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self?.alpha = 0
        }
    }
    
    private func setupIndicator() {
        if showCircleIndicator {
            addCircleIndicator()
        } else {
            addActivityIndicator()
        }
    }
    
    private func addCircleIndicator() {
        let indicator = AKActivityImageIndicatorView(frame: CGRect(x: 0, y: 0, width: indicatorSize, height: indicatorSize))
        self.addSubview(indicator)
        indicator.center = CGPoint(x: self.frame.size.width / 2, y:  self.frame.size.height / 2)
        indicator.setup()
    }
    
    private func addActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = indicatorColor
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: self.frame.size.width / 2, y:  self.frame.size.height / 2)
    }
    
    private class func view(for view: UIView) -> UIView? {
        if UIApplication.shared.keyboardView() != nil {
            return view.superview
        }
        return view
    }
}

//MARK : - CircleIndicatorView

class AKActivityCircleIndicatorView: UIView {
    
    var lineWidth: CGFloat = 1.5
    var circleColor: UIColor = .gray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup(circleColor: UIColor? = nil) {
        if circleColor != nil {
            setNeedsDisplay()
            self.circleColor = circleColor!
        }
        setNeedsDisplay()
        backgroundColor = .clear
        spinLayer(layer: self.layer, duration: 1, direction: 1)
    }
    
    func spinLayer(layer: CALayer, duration: CFTimeInterval, direction: Int) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Float.pi * 2.0 * Float(direction))
        rotation.duration = duration
        rotation.repeatCount = 100000
        layer.add(rotation, forKey: "rotationAnimation")
    }
    
    override func draw(_ rect: CGRect) {
        let bounds = self.bounds
        let radius = bounds.size.width / 2 - lineWidth
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        var center = CGPoint()
        center.x = bounds.origin.x + bounds.size.width / 2.0
        center.y = bounds.origin.y + bounds.size.height / 2.0
        ctx.saveGState()
        
        ctx.setLineWidth(lineWidth)
        ctx.setStrokeColor(circleColor.cgColor)
        ctx.addArc(center: center, radius: radius , startAngle: 0.0, endAngle: CGFloat(Float.pi * 2.0 + 0.5), clockwise: true)
        ctx.strokePath()
    }
}

class AKActivityImageIndicatorView: UIView {
    
    private let INDICATOR_TAG = 777777
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
        
    func setup() {
        backgroundColor = .clear
        if (self.viewWithTag(INDICATOR_TAG) == nil) {
            let imageView = UIImageView(frame: self.frame)
            imageView.tag = INDICATOR_TAG
            imageView.image = UIImage(named: "ic_activity")
            self.addSubview(imageView)
        }
        spinLayer(view: self, duration: 1, direction: 1)
    }
    
    func spinLayer(view: UIView, duration: CFTimeInterval, direction: Int) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Float.pi * 2.0 * Float(direction))
        rotation.duration = duration
        rotation.repeatCount = 100000
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
}

extension UIApplication {
    
    func keyboardView() -> UIView? {
        let windows = self.windows
        for window in windows.reversed() {
            for view in window.subviews {
                let className = String(describing: view.self)
                if className != "UIPeripheralHostView" || className != "UIKeyboard" {
                    return view
                }
            }
        }
        return nil
    }
}

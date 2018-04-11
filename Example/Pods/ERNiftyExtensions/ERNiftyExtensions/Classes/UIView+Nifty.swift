//
//  UIView+Nifty.swift
//  Pods
//
//  Created by Ephraim Russo on 6/5/17.
//
//

extension UIView {
    
    public func containingViewController() -> UIViewController? {
        
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }
    
    @nonobjc public class func fromNib<T : UIView>(_ nibNameOrNil: String? = nil) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = T.classString
        }
        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        for v in nibViews! {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }
    
    @nonobjc public class func fromNib<T : UIView>(_ nibNameOrNil: String? = nil) -> T {
        let v: T? = fromNib(nibNameOrNil)
        return v!
    }
    
    public var gradient: CAGradientLayer? {
        
        get { return self.layer.sublayer(withName: "nifty_gradient_key") as? CAGradientLayer }
        
        set {
            
            if newValue == nil {
                let g = self.layer.sublayer(withName: "nifty_gradient_key") as! CAGradientLayer
                g.removeFromSuperlayer()
            }
                
            else {
                
                newValue!.frame = self.bounds
                newValue!.name = "nifty_gradient_key"
                self.layer.addSublayer(newValue!)
            }
        }
    }
    
    public var snapshotImage:UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return screenshot
    }
    
    public var internalCenter:CGPoint {return CGPoint(x: frame.size.width/2, y: frame.size.height/2)}
    
    public func rotateByDegrees(_ degrees: CGFloat) {
        let radians:CGFloat = ((degrees * CGFloat(Double.pi)) / 180.0)
        self.rotateByRadians(radians)
    }
    
    public func rotateByRadians(_ radians: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
    
    public func addShadowWithRadius(_ radius: CGFloat, opacity: Float, xOffset: CGFloat, yOffset: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shadowRadius = radius
    }
    
    public func snapShotImageUsingRect(_ rect:CGRect) -> UIImage? {
        
        guard let image = snapshotImage else {return nil}
        
        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }
    
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    
    public func shake(count : Float = 4,for duration : TimeInterval = 0.3,withTranslation translation : Float = 16) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation
        self.layer.add(animation, forKey: "shake")
    }
}

extension UIView {
    
    @IBInspectable public var borderColor:UIColor? {
        
        set { layer.borderColor = newValue?.cgColor }
        
        get {
            guard let color = layer.borderColor else {return nil}
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable public var borderWidth:CGFloat {
        
        set { layer.borderWidth = newValue }
        
        get { return layer.borderWidth }
    }
    
    @IBInspectable public var cornerRadius:CGFloat {
        
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        
        get { return layer.cornerRadius }
    }
}


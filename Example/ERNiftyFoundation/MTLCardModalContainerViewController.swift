//
//  File.swift
//  MetalPay
//
//  Created by Ephraim Russo on 10/6/17.
//  Copyright © 2017 Metallicus Inc. All rights reserved.
//

import UIKit

class MTLCardModalContainerViewController: UIViewController {
    
    //**************************************************//
    
    // MARK: Static Variables
    
    //**************************************************//
    
    // MARK: Public Variables
    
    //**************************************************//
    
    // MARK: Private Variables
    
    /// The pan gesture recognizer that handles interactive dismissing.
    fileprivate var panGestureRecognizer: UIPanGestureRecognizer!
    
    /// The tap gesture recognizer that handles tap-to-dismiss in the out-of-container area.
    fileprivate var tapGestureRecognizer: UITapGestureRecognizer!
    
    /// The presenting view controller's end scale after this controller is presented.
    fileprivate var presentingEndScale: CGFloat = 0.94
    
    /// The origin point used for tracking and restoring.
    fileprivate var originPoint: CGPoint!
    
    /// The view controller that is embedded within the container.
    fileprivate(set) var embeddedViewController: UIViewController! {
        
        didSet {
            
            // Add the embedded controller as a child.
            self.addChildViewController(embeddedViewController)
            
            // Remove auto resizing constraints.
            embeddedViewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            // Add the embedded controller to the content view.
            self.contentView.addSubview(embeddedViewController.view)
            
            // Constrain the embedded controller's view to the bounds of the content view.
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|", options: [], metrics: nil, views: ["childView": embeddedViewController.view]))
            
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|", options: [], metrics: nil, views: ["childView": embeddedViewController.view]))
            
            // Call did move on embedded controller.
            embeddedViewController.didMove(toParentViewController: self)
            
            embeddedViewController.definesPresentationContext = true
        }
    }
    
    /// The dimming view applied to the presenting view.
    fileprivate lazy var dimmingView: UIView = {
        let dimmingView = UIView()
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        dimmingView.alpha = 0
        return dimmingView
    }()
    
    //**************************************************//
    
    // MARK: Computed Variables
    
    /// Recursively gets the embedded scroll view, if one exists. This is so we can override its gesture recognizers.
    fileprivate lazy var embeddedScrollView: UIScrollView? = {
        let scrollViews: [UIScrollView] = getSubviewsOf(view: self.contentView)
        return scrollViews.first
    }()
    
    //**************************************************//
    
    // MARK: Manager
    
    //**************************************************//
    
    // MARK: IBOutlets
    
    @IBOutlet fileprivate weak var topPaddingConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var contentView: UIView!
    
    //**************************************************//
    
    // MARK: IBActions
    
    //**************************************************//
    
    // MARK: View Loading
    
    override func awakeFromNib() {
        super.awakeFromNib()
        modalPresentationStyle = .overCurrentContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContentView()
        loadTapGestureRecognizer()
        loadPanGestureRecognizer()
        loadEmbeddedScrollViewIfNeeded()
    }
    
    fileprivate func loadContentView() {
        
        contentView.cornerRadius = 10
    }
    
    fileprivate func loadTapGestureRecognizer() {
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized(_:)))
        self.tapGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(self.tapGestureRecognizer)
    }
    
    fileprivate func loadPanGestureRecognizer() {
        
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:)))
        self.panGestureRecognizer.delegate = self
        self.contentView.addGestureRecognizer(self.panGestureRecognizer)
    }
    
    fileprivate func loadEmbeddedScrollViewIfNeeded() {
        
        if embeddedViewController != nil { print("Embedded scroll view exists!") }
        
        embeddedScrollView?.showsVerticalScrollIndicator = false
        embeddedScrollView?.showsHorizontalScrollIndicator = false
        embeddedScrollView?.keyboardDismissMode = .onDrag
        embeddedScrollView?.delegate = self
    }
    
    //**************************************************//
    
    // MARK: View Appearance
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animatePresentingViewFor(isPresenting: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //**************************************************//
    
    // MARK: Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Override point to pass data to the destination view controller.
        super.prepare(for: segue, sender: sender)
    }
    
    //**************************************************//
    
    // MARK: Dismiss
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        
        if presentedViewController == nil { animatePresentingViewFor(isPresenting: false) }
        
        self.animateContentViewFor(isPresenting: false) { _ in
            
            super.dismiss(animated: false, completion: completion)
            
        }
    }
    
    //**************************************************//
    
    // MARK: View Disappearance
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Override point to customize time before presentation or push.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Override point to customize time after presentation or push.
    }
    
    //**************************************************//
    
    // MARK: Configuration
    
    public func embedViewController(controller: UIViewController) {
        
        self.embeddedViewController = controller
    }
    
    //**************************************************//
    
    // MARK: Animations
    
    fileprivate func animatePresentingViewFor(isPresenting: Bool, completion: ((Bool) -> Void)? = nil) {
        
        if self.dimmingView.superview == nil {
            
            guard let presenter = self.presentingViewController else {return}
            
            self.dimmingView.frame = presenter.view.bounds
            presenter.view.addSubview(self.dimmingView)
        }
        
        self.tapGestureRecognizer.isEnabled = false
        
        UIView.animate(withDuration: 0.275, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            
            self.presentingViewController?.view.transform = isPresenting ? CGAffineTransform(scaleX: self.presentingEndScale, y: self.presentingEndScale) : .identity
            self.dimmingView.alpha = isPresenting ? 1 : 0
            
        }) { finished in
            
            self.tapGestureRecognizer.isEnabled = true
            
            completion?(finished)
        }
    }
    
    fileprivate func animateContentViewFor(isPresenting: Bool, completion: ((Bool) -> Void)? = nil) {
        
        let duration: TimeInterval = isPresenting ? 0.55 : 0.25
        
        let options: UIViewAnimationOptions = [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction]
        
        self.view.isUserInteractionEnabled = false
        self.panGestureRecognizer.isEnabled = false
        self.tapGestureRecognizer.isEnabled = false
        
        let block: (Bool) -> Void = { finished in
            
            self.view.isUserInteractionEnabled = true
            self.panGestureRecognizer.isEnabled = true
            self.tapGestureRecognizer.isEnabled = true
            
            completion?(finished)
        }
        
        if isPresenting { UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: options, animations: { self.contentView.frame.origin.y = self.topPaddingConstraint.constant }, completion: block) }
            
        else { UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: { self.contentView.frame.origin.y = UIScreen.main.bounds.height } , completion: block) }
    }
    
    //**************************************************//
    
    // MARK: Gesture Recognizers
    
    @objc fileprivate func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        
        //print(translation.y)
        
        switch sender.state {
            
        case .began:
            
            self.view.endEditing(true)
            
            self.panningDidBegin()
            
            originPoint = self.contentView.frame.origin
            
        case .changed:
            
            //let canMove = (senderViewController is MTLCardModalDisplayable) ? (senderViewController as! MTLCardModalDisplayable).scrollView.contentOffset.y <= 0 : true
            
            guard translation.y > 0 /*&& canMove*/ else {return}
            
            let scalePercentage: CGFloat = translation.y / (self.contentView.frame.size.height)
            
            let bottomScale = max(presentingEndScale*(1.0+(scalePercentage/10.0)), presentingEndScale)
            
            let dimmingAlpha = min(1 - scalePercentage, 1.0)
            
            self.dimmingView.alpha = dimmingAlpha
            
            self.contentView.frame.origin.y = originPoint.y + translation.y
            
            presentingViewController?.view.transform = CGAffineTransform(scaleX: bottomScale, y: bottomScale)
            
        case .ended, .cancelled:
            
            let threshold = floor(self.contentView.frame.size.height/4)
            
            let canDismissWithVelocity = /*(senderViewController is MTLCardModalDisplayable) ? (sender.view as! UIScrollView).contentOffset.y <= 0 :*/ true
            
            if (translation.y > threshold) && canDismissWithVelocity {
                
                self.panningDidEnd(willPresent: false)
                
                self.animatePresentingViewFor(isPresenting: false)
                
                self.dismiss(animated: true)
            }
                
            else {
                
                self.panningDidEnd(willPresent: true)
                self.animatePresentingViewFor(isPresenting: true)
                self.animateContentViewFor(isPresenting: true)
            }
            
        default: break
        }
    }
    
    @objc fileprivate func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        
        guard sender.location(in: self.view).y <= topPaddingConstraint.constant else {return}
        
        dismiss(animated: true, completion: nil)
    }
    
    //**************************************************//
    
    // MARK: Events
    
    public func panningDidBegin() {
        
    }
    
    public func panningDidEnd(willPresent: Bool) {
        
    }
    
    //**************************************************//
    
    // MARK: Status Bar
    
    override var prefersStatusBarHidden: Bool { return true }
    
    //**************************************************//
}

extension MTLCardModalContainerViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        scrollView.bounces = scrollView.contentOffset.y > 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        scrollView.bounces = targetContentOffset.pointee.y >= 0
    }
}

extension MTLCardModalContainerViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let scrollView = self.embeddedScrollView { return scrollView.contentOffset.y == 0 }
            
        else { return false }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        guard gestureRecognizer == self.tapGestureRecognizer else {return true}
        
        return touch.location(in: self.view).y <= topPaddingConstraint.constant
    }
}

extension MTLCardModalContainerViewController {
    
    fileprivate func getSubviewsOf<T: UIView>(view: UIView) -> [T] {
        var subviews = [T]()
        
        for subview in view.subviews {
            subviews += getSubviewsOf(view: subview) as [T]
            
            if let subview = subview as? T {
                subviews.append(subview)
            }
        }
        
        return subviews
    }
}

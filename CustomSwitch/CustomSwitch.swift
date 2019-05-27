//
//  CustomSwitch.swift
//  CustomSwitch
//
//  Created by Ivan Kovacevic on 15/12/2016.
//  Copyright © 2016 Ivan Kovacevic. All rights reserved.
//

import UIKit

@IBDesignable
final class CustomSwitch: UIControl {
    static let DefaultTintColor = UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
    var onLabelText:String  =   "ON"
    var offLabelText:String  =   "OFF"
    public var animationDuration: Double = 0.5
    @IBInspectable  public var padding: CGFloat = 1 {
        didSet {
            self.layoutSubviews()
        }
    }
    @IBInspectable  public var onTintColor: UIColor = UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 1) {
        didSet {
            self.setupUI()
        }
    }
    @IBInspectable public var offTintColor: UIColor = UIColor.white {
        didSet {
            self.setupUI()
        }
    }
    var isOn: Bool = true {
        didSet {
            self.isAnimating = true
            self.thumbTintColor = isOn ? self.offTintColor : self.onTintColor
            self.labelOn.textColor = self.isOn ? self.offTintColor : self.onTintColor
            self.labelOn.text = self.isOn ? self.onLabelText : self.offLabelText
            self.labelOn.textAlignment = self.isOn ? .left : .right
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction], animations: {
                self.setupViewsOnAction()
            }, completion: { _ in
                self.isAnimating = false
            })
        }
    }
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return self.privateCornerRadius
        }
        set {
            if newValue > 0.5 || newValue < 0.0 {
                privateCornerRadius = 0.5
            } else {
                privateCornerRadius = newValue
            }
        }
    }
    private var privateCornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }
    @IBInspectable public var thumbTintColor: UIColor = UIColor.white {
        didSet {
            self.thumbView.backgroundColor = self.thumbTintColor
        }
    }
    
    @IBInspectable public var thumbCornerRadius: CGFloat {
        get {
            return self.privateThumbCornerRadius
        }
        set {
            if newValue > 0.5 || newValue < 0.0 {
                privateThumbCornerRadius = 0.5
            } else {
                privateThumbCornerRadius = newValue
            }
        }
    }
    
    private var privateThumbCornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }
    @IBInspectable public var thumbSize: CGSize = CGSize.zero {
        didSet {
            self.layoutSubviews()
        }
    }
    
    @IBInspectable public var thumbImage:UIImage? = nil
    public var onImage:UIImage?
    public var offImage:UIImage?
    @IBInspectable public var borderColor: UIColor =  UIColor.init(red: 74/255, green: 144/255, blue: 226/255, alpha: 1){
        didSet {
              self.layer.borderColor = self.borderColor.cgColor
        }
    }
    @IBInspectable public var thumbShadowColor: UIColor = UIColor.black
    @IBInspectable public var thumbShadowOffset: CGSize = CGSize(width: 0.75, height: 2)
    @IBInspectable public var thumbShaddowRadius: CGFloat = 1.5
    @IBInspectable public var thumbShaddowOppacity: Float = 0.4
    public var labelOn:UILabel = UILabel()
    public var areLabelsShown: Bool = true {
        didSet {
            self.setupUI()
        }
    }
    fileprivate var thumbView = CustomThumbView(frame: CGRect.zero)
    fileprivate var onImageView = UIImageView(frame: CGRect.zero)
    fileprivate var offImageView = UIImageView(frame: CGRect.zero)
    fileprivate var onPoint = CGPoint.zero
    fileprivate var offPoint = CGPoint.zero
    fileprivate var isAnimating = false
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
}
extension CustomSwitch {
    fileprivate func setupUI() {
        self.clear()
        self.clipsToBounds = false
        self.cornerRadius = 0.5
        self.thumbCornerRadius = 0.5
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.borderWidth = 1
        self.padding = 3
        self.animationDuration = 0.6
        self.thumbShaddowOppacity = 0
        self.thumbTintColor = isOn ? self.offTintColor : self.onTintColor
        self.labelOn.textColor = self.isOn ? self.offTintColor : self.onTintColor
        self.labelOn.text = self.isOn ? self.onLabelText : self.offLabelText
        self.thumbSize = CGSize(width: 14, height:14)
        self.thumbView.backgroundColor = self.thumbTintColor
        self.thumbView.isUserInteractionEnabled = false
        self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        self.addSubview(self.thumbView)
        self.addSubview(self.onImageView)
        self.addSubview(self.offImageView)
        self.setupLabels()
    }
    private func clear() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        self.animate()
        return true
    }
    func setOn(on:Bool, animated:Bool) {
        switch animated {
        case true:
            self.animate(on: on)
        case false:
            self.isOn = on
            self.setupViewsOnAction()
        }
    }
    fileprivate func animate(on:Bool? = nil) {
        self.isOn = on ?? !self.isOn
        self.isAnimating = true
        self.thumbTintColor = isOn ? self.offTintColor : self.onTintColor
        self.labelOn.textColor = self.isOn ? self.offTintColor : self.onTintColor
        self.labelOn.text = self.isOn ? self.onLabelText : self.offLabelText
        self.labelOn.textAlignment = self.isOn ? .left : .right
        self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.allowUserInteraction], animations: {
            self.setupViewsOnAction()
            
        }, completion: { _ in
            self.completeAction()
        })
    }
    
    func setupViewsOnAction() {
        self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
        self.thumbTintColor = isOn ? self.offTintColor : self.onTintColor
        self.labelOn.textColor = self.isOn ? self.offTintColor : self.onTintColor
        self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        self.setOnOffImageFrame()
    }
    private func completeAction() {
        self.isAnimating = false
        self.sendActions(for: UIControl.Event.valueChanged)
    }
}

// Mark: Public methods
extension CustomSwitch {
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isAnimating {
            self.layer.cornerRadius = self.bounds.size.height * self.cornerRadius
            self.thumbTintColor = isOn ? self.offTintColor : self.onTintColor
            self.labelOn.textColor = self.isOn ? self.offTintColor : self.onTintColor
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(width: self.bounds.size.height - 2, height: self.bounds.height - 2)
            let yPostition = (self.bounds.size.height - thumbSize.height) / 2
            self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding, y: yPostition)
            self.offPoint = CGPoint(x: self.padding, y: yPostition)
            self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)
            self.thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius
            if self.areLabelsShown {
                self.labelOn.frame = CGRect(x: 5, y: 0, width: self.frame.width - 8, height: self.frame.height)
            }
            guard onImage != nil && offImage != nil else {
                return
            }
            let frameSize = thumbSize.width > thumbSize.height ? thumbSize.height * 0.7 : thumbSize.width * 0.7
            let onOffImageSize = CGSize(width: frameSize, height: frameSize)
            self.onImageView.frame.size = onOffImageSize
            self.offImageView.frame.size = onOffImageSize
            self.onImageView.center = CGPoint(x: self.onPoint.x + self.thumbView.frame.size.width / 2, y: self.thumbView.center.y)
            self.offImageView.center = CGPoint(x: self.offPoint.x + self.thumbView.frame.size.width / 2, y: self.thumbView.center.y)
            self.onImageView.alpha = self.isOn ? 1.0 : 0.0
            self.offImageView.alpha = self.isOn ? 0.0 : 1.0
        }
    }
}

//Mark: Labels frame
extension CustomSwitch {
    fileprivate func setupLabels() {
        guard self.areLabelsShown else {
            self.labelOn.alpha = 0
            return
        }
        self.labelOn.alpha = 1
        self.labelOn.frame = CGRect(x: 5, y: 0, width: self.frame.width - 8 , height: self.frame.height)
        self.labelOn.font = UIFont.boldSystemFont(ofSize: 9)
        self.labelOn.textAlignment = self.isOn ? .left : .right
        self.insertSubview(self.labelOn, belowSubview: self.thumbView)
    }
}

//Mark: Animating on/off images
extension CustomSwitch {
    fileprivate func setOnOffImageFrame() {
        guard onImage != nil && offImage != nil else {
            return
        }
        self.onImageView.center.x = self.isOn ? self.onPoint.x + self.thumbView.frame.size.width / 2 : self.frame.width
        self.offImageView.center.x = !self.isOn ? self.offPoint.x + self.thumbView.frame.size.width / 2 : 0
        self.onImageView.alpha = self.isOn ? 1.0 : 0.0
        self.offImageView.alpha = self.isOn ? 0.0 : 1.0
    }
}
final class CustomThumbView: UIView {
    fileprivate(set) var thumbImageView = UIImageView(frame: CGRect.zero)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.thumbImageView)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(self.thumbImageView)
    }
}

extension CustomThumbView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.thumbImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.thumbImageView.layer.cornerRadius = self.layer.cornerRadius
        self.thumbImageView.clipsToBounds = self.clipsToBounds
    }
}


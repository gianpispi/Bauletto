//
//  BaulettoView.swift
//  
//
//  Created by Gianpiero Spinelli on 05/03/2020.
//

import Foundation
import UIKit

internal class BaulettoView: UIView {
    private var stackView: UIStackView = UIStackView()
    private var iconView: UIImageView = UIImageView()
    private var containerView: UIVisualEffectView = UIVisualEffectView()
    private var titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        l.numberOfLines = 1
        return l
    }()
    
    private var viewTranslation = CGPoint(x: 0, y: 0)
    
    /// Show time duration, seconds before the banner goes off.
    public var dismissMode: BaulettoDismissMode = .automatic
    
    public var fadeInAnimation: TimeInterval? = 1
    
    /// Icon that goes at the left of the text
    private var icon: UIImage? {
        didSet {
            self.iconView.image = icon
        }
    }
    
    /// Text that goes at the right of the image
    private var title: String? = "It works" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    /// Tint color for icon and
    open override var tintColor: UIColor! {
        didSet {
            self.iconView.tintColor = tintColor
            self.titleLabel.textColor = tintColor
        }
    }
    
    /// Style of the background UIVisualEffectView
    private var backgroundStyle: UIBlurEffect.Style! {
        didSet {
            self.containerView.effect = UIBlurEffect(style: backgroundStyle)
        }
    }
    
    /// Action that needs to be performed when tapping Bauletto view
    private var action: (() -> Void)? = nil
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialize()
    }
    
    /// Function that adds all the subviews to the view - remember to call the super.initialize() when override it.
    open func initialize() {
        if #available(iOS 13, *) {
            tintColor = .secondaryLabel
            backgroundStyle = .systemChromeMaterial
            icon = nil
        } else {
            tintColor = .darkGray
            backgroundStyle = .regular
        }
        
        titleLabel.text = title
        iconView.image = icon
        
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(titleLabel)
        
        containerView.contentView.addSubview(stackView)
        addSubview(containerView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        self.containerView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapAction))
        
        self.containerView.addGestureRecognizer(gestureRecognizer)
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss(sender:))))
    }
    
    @objc private func handleTapAction() {
        action?()
    }
    
    public func update(withSettings settings: BaulettoSettings?) {
        self.icon = settings?.icon
        
        if let settings = settings, settings.icon == nil {
            stackView.removeArrangedSubview(iconView)
        }
        
        self.title = settings?.title ?? self.title
        self.tintColor = settings?.tintColor ?? self.tintColor
        self.backgroundStyle = settings?.backgroundStyle ?? self.backgroundStyle
        self.dismissMode = settings?.dismissMode ?? self.dismissMode
        self.action = settings?.action
        self.fadeInAnimation = settings?.fadeInDuration
    }
    
    public func animateIcon() {
        iconView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: fadeInAnimation ?? 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.iconView.transform = .identity
        }, completion: nil)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.layer.cornerRadius = min(frame.size.height, frame.size.width) / 2
        containerView.layer.masksToBounds = true
        
        layer.shadowOpacity = 0.4
        layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 7
    }
}

extension BaulettoView {
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: self)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
        case .ended:
            print(viewTranslation.y)
            
            if viewTranslation.y > 10 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.transform = .identity
                })
            } else {
                Bauletto.hide()
//                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
}

public class Bauletto {
    public enum QueuePosition {
        case beginning, end
    }
    
    fileprivate var bannerView: BaulettoView? = nil
    fileprivate var timer: Timer? = nil
    
    private var queue: [BaulettoSettings?] = []
    
    fileprivate func getBannerView() -> BaulettoView {
        let bannerView = BaulettoView()
        return bannerView
    }
    
    /// - `Banner` shared instance
    public static var shared = Bauletto()
    
    /// Currently shown Bauletto View
    public var currentBanner: UIView? {
        return bannerView
    }
    
    /// Flag to handle the slideIn animation on showup. By default it is connected to the Accessibility reduce motion setting.
    public var animated: Bool = !UIAccessibility.isReduceMotionEnabled
    
    /// Getting the key window of the current app.
    /// Returns 'UIWindow'.
    fileprivate let keyWindow: UIWindow? = {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .first { $0.activationState == .foregroundActive }
                .map { $0 as? UIWindowScene }
                .map { $0?.windows.first } ?? UIApplication.shared.delegate?.window ?? nil
        }

        return UIApplication.shared.delegate?.window ?? nil
    }()
    
    /// Shows the banner view
    /// - Parameters:
    ///   - settings: BannerSettings which sets the banner's appearance (eg. tintColor, icon...)
    ///   - animated: Flag to handle the slideIn animation on showup. It overrides the shared  `animated` value.
    ///   - queuePosition: Position in the queue. Added at the end by default.
    public static func show(withSettings settings: BaulettoSettings?, _ animated: Bool? = nil, queuePosition: QueuePosition = .end) {
        if let animated = animated {
            shared.animated = animated
        }
        
        shared.addToQueue(withSettings: settings, position: queuePosition)
        shared.showNext()
    }
    
    private static func showBannerView(withSettings settings: BaulettoSettings?) {
        shared.bannerView = shared.getBannerView()
        shared.bannerView?.update(withSettings: settings)
        
        guard let window = shared.keyWindow, let bannerView = shared.bannerView else { return }
        
        window.addSubview(bannerView)
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        var topConstant: CGFloat
        if #available(iOS 11, *) {
            topConstant = window.safeAreaInsets.top + 15
        } else {
            topConstant = 15
        }
        
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: window.topAnchor, constant: topConstant),
            bannerView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            bannerView.leadingAnchor.constraint(greaterThanOrEqualTo: window.leadingAnchor, constant: 20),
            bannerView.trailingAnchor.constraint(lessThanOrEqualTo: window.trailingAnchor, constant: -20),
        ])
        
        if let style = settings?.hapticStyle {
            FeedbackGenerator.generate(withStyle: style)
        }
        
        shared.playFadeInAnimation(animated: shared.animated) { _ in
            shared.prepareToHide(bannerView: bannerView)
        }
    }
    
    /// Plays fade in animation
    private func playFadeInAnimation(animated: Bool, _ completion: ((Bool) -> Void)?) {
        guard let window = keyWindow, let bannerView = bannerView else { return }
        
        if animated {
            var y: CGFloat
            if #available(iOS 11, *) {
                y = -(bannerView.bounds.height + window.safeAreaInsets.top + 10)
            } else {
                y = -(bannerView.bounds.height + 10)
            }
            
            bannerView.transform = CGAffineTransform(translationX: 0, y: y)
            
            bannerView.animateIcon()
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
                bannerView.transform = .identity
            }, completion: completion)
        } else {
            bannerView.alpha = 0
            
            UIView.animate(withDuration: 0.25, animations: {
                bannerView.alpha = 1
            }, completion: completion)
        }
    }
    
    private func prepareToHide(bannerView: BaulettoView) {
        if bannerView.dismissMode != .never {
            self.timer = Timer.scheduledTimer(timeInterval: bannerView.dismissMode.duration, target: self, selector: #selector(self.hide), userInfo: nil, repeats: false)
        }
    }
    
    private func playFadeOutAnimation(animated: Bool, _ completion: ((Bool) -> Void)?) {
        guard let window = keyWindow, let bannerView = bannerView else {
            completion?(false)
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            if animated {
                var y: CGFloat
                if #available(iOS 11, *) {
                    y = -(bannerView.bounds.height + window.safeAreaInsets.top + 10)
                } else {
                    y = -(bannerView.bounds.height + 10)
                }
                
                bannerView.transform = CGAffineTransform(translationX: 0, y: y)
            } else {
                bannerView.alpha = 0
            }
        }, completion: completion)
    }
    
    @objc private func hide() {
        Bauletto.hide()
    }
    
    /// Hides the banner view
    /// - Parameter animated: Flag to handle the slideOut animation on dismiss. By default it is connected to the Accessibility reduce motion setting.
    /// - Parameter completion: Flag to handle the slideOut animation on hide. It overrides the shared  `animated` value.
    public static func hide(_ animated: Bool? = nil, completion: (() -> ())? = nil) {
        if let animated = animated {
            shared.animated = animated
        }
        
        func hideProgressHud() {
            shared.bannerView?.removeFromSuperview()
            shared.bannerView = nil
        }
        
        shared.timer?.invalidate()
        
        DispatchQueue.main.async {
            shared.playFadeOutAnimation(animated: shared.animated, { success in
                guard success else {
                    completion?()
                    return
                }
                
                hideProgressHud()
                
                shared.queue.removeFirst()
                
                if shared.queue.isEmpty {
                    DispatchQueue.main.async {
                        completion?()
                    }
                } else {
                    shared.showNext()
                }
            })
        }
    }
    
    // MARK: - QUEUE
    private func addToQueue(withSettings settings: BaulettoSettings?, position: QueuePosition) {
        switch position {
        case .beginning:
            queue.insert(settings, at: 0)
        case .end:
            queue.append(settings)
        }
    }
    
    private func showNext() {
        if let next = queue.first {
            if bannerView == nil {
                Bauletto.showBannerView(withSettings: next)
            }
        }
    }
    
    public func forceShowNext() {
        if let _ = queue.first {
            Bauletto.hide(completion: nil)
        }
    }
    
    public func removeBannersInQueue() {
        queue.removeAll()
    }
}

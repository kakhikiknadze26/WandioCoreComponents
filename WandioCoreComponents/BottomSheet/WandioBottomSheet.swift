//
//  WandioBottomSheet.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/19/20.
//

import UIKit

open class WandioBottomSheet: UIView {
    
    public weak var delegate: WandioBottomSheetDelegate?
    public var dismissBlock: (() -> Void)?
    public var isPresented = false
    
    internal let handleArea = UIView()
    internal let contentView = UIView()
    
    open var backgroundView = UIView()
    open var contentHeight: CGFloat?
    open var handleHeight: CGFloat?
    open var hasBackground = true
    
    internal var topConstraint: NSLayoutConstraint?
    internal var originalTopConstraintConstant: CGFloat = .zero
    internal var validContentHeight: CGFloat {
        contentView.layoutIfNeeded()
        return contentHeight ?? contentView.frame.height
    }
    internal var validHandleHeight: CGFloat {
        handleArea.layoutIfNeeded()
        return handleHeight ?? handleArea.frame.height
    }
    private var sheetHeight: CGFloat {
        validHandleHeight + validContentHeight
    }
    
    public var isExpanded = false
    internal var shouldDismiss = false
    private var nextState: CardState {
        isExpanded ? .collapsed : .expanded
    }
    
    // MARK: - Initialize
    deinit {
        print("WandioBottomSheet Deinitialized!!!")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        configureUI()
        addGestures()
    }
    
    // MARK: - Content
    /// Add content as subview in` contentView` or insert it at provided index. Index is `nil` by default.
    /// - Parameters:
    ///   - content: Your custom view
    ///   - index: Index to insert content at.
    open func addContent(_ content: UIView, at index: Int? = nil) {
        if let index = index {
            contentView.insertSubview(content, at: index)
        } else {
            contentView.addSubview(content)
        }
        content.stretchLayout()
    }
    
    /// Add custom handle view in `handlerArea` or insert it at provided index. Index is `nil` by default.
    /// - Parameters:
    ///   - handle: Your custom handle view
    ///   - index: Index to insert handle at.
    open func addHandle(_ handle: UIView, at index: Int? = nil) {
        if let index = index {
            handleArea.insertSubview(handle, at: index)
        } else {
            handleArea.addSubview(handle)
        }
        handle.stretchLayout()
    }
    
    // MARK: - UI
    private func configureUI() {
        backgroundColor = .clear
        setupBackgroundView()
        addHandleArea()
        addContentView()
    }
    
    private func addContentView() {
        contentView.backgroundColor = .white
        addSubview(contentView)
        setupContentViewConstraints()
    }
    
    private func setupContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: handleArea.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func addHandleArea() {
        addSubview(handleArea)
        setupHandleAreaConstraints()
    }
    
    private func setupHandleAreaConstraints() {
        handleArea.translatesAutoresizingMaskIntoConstraints = false
        handleArea.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        handleArea.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        guard let handleHeight = handleHeight else { return }
        handleArea.heightAnchor.constraint(equalToConstant: handleHeight).isActive = true
    }
    
    private func setupBackgroundView() {
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.4
    }
    
    private func addBackground(on view: UIView) {
        view.addSubview(backgroundView)
        backgroundView.frame = view.bounds
    }
    
    open func removeBackground(animated: Bool = true) {
        if animated {
            animateBackgroundViewRemove()
        } else {
            backgroundView.removeFromSuperview()
            hasBackground = false
        }
    }
    
}

// MARK: - Presentation
extension WandioBottomSheet {

    /// Present bottom sheet on view controller
    /// - Parameters:
    ///   - viewController: Presenting view controller
    ///   - animated: Present with animation. Default is `true`
    ///   - completion: Completion block. Default is `nil`
    open func present(on viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(on: viewController.view, animated: animated, completion: completion)
    }

    /// Presents bottom sheet on view
    /// - Parameters:
    ///   - view: Presenting view
    ///   - animated: Present with animation. Default is `true`
    ///   - completion: Completion block. Default is `nil`
    open func present(on view: UIView, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard !isPresented else { return }
        if hasBackground {
            addBackground(on: view)
        }
        view.addSubview(self)
        frame = view.bounds
        addTopConstraintOnHandlerArea()
        if animated {
            animatePresent(on: view, completion: completion)
        } else {
            isPresented = true
            completion?()
        }
    }

    /// Dismiss bottom sheet with animation and completion
    /// - Parameters:
    ///   - animated: Dismiss with animation. Default is `true`
    ///   - completion: Completion block. Default is `nil`
    open func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard isPresented else { return }
        guard animated else {
            removeFromSuperview()
            self.backgroundView.removeFromSuperview()
            completion?()
            return
        }
        animateDismiss(completion: completion)
    }

    private func addTopConstraintOnHandlerArea() {
        let height = bounds.height - sheetHeight
        let constant: CGFloat = max(0, height - safeAreaInsets.top - safeAreaInsets.bottom)
        originalTopConstraintConstant = constant
        topConstraint = handleArea.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: constant)
        topConstraint?.isActive = true
    }

}

// MARK: - Animations
extension WandioBottomSheet {
    
    /// Presentation animation
    private func animatePresent(on view: UIView, completion: (() -> Void)? = nil) {
        transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        backgroundView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.transform = .identity
            self.backgroundView.alpha = 0.4
        } completion: { _ in
            self.isPresented = true
            completion?()
        }
    }
    
    /// Dismiss animation
    private func animateDismiss(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.transform = CGAffineTransform(translationX: 0, y: self.superview?.frame.height ?? 0)
            self.backgroundView.alpha = 0
        } completion: { _ in
            self.isPresented = false
            self.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
            self.transform = .identity
            completion?()
        }
    }

    /// Background remove animation
    private func animateBackgroundViewRemove() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.backgroundView.alpha = 0
        } completion: { _ in
            self.backgroundView.removeFromSuperview()
            self.hasBackground = false
        }
    }
    
}

// MARK: - Handle Pull Up/Down
extension WandioBottomSheet {

    private enum CardState {
        case expanded, collapsed
    }
    
    private func addGestures() {
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapBackground)))
        handleArea.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(recognizer:))))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:))))
    }

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView === self {
            return nil
        }
        return hitView
    }

    @objc private func didTapBackground() {
        dismiss(animated: true, completion: dismissBlock)
    }

    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            expand(nextState == .expanded)
        }
    }

    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        guard !(isExpanded && translation.y < .zero) else { return }
        switch recognizer.state {
        case .began:
            beganPanGesture(recognizer)
        case .changed:
            changedPanGesture(recognizer)
        case .ended:
            endedPanGesture(recognizer)
        default:
            break
        }
    }

    private func expand(_ expand: Bool) {
        topConstraint?.constant = expand ? 0 : originalTopConstraintConstant
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.layoutIfNeeded()
        } completion: { _ in
            self.isExpanded.toggle()
        }
    }

    open func beganPanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        guard !(isExpanded && translation.y < .zero) else { return }
        shouldDismiss = (translation.y > .zero && !isExpanded)
        delegate?.bottomSheet(self, didBeginPanGesture: recognizer)
    }

    open func changedPanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        let newConstant = max(0, (topConstraint?.constant ?? 0) + translation.y)
        topConstraint?.constant = newConstant
        recognizer.setTranslation(.zero, in: self)
        delegate?.bottomSheet(self, didChangePanGesture: recognizer)
    }

    open func endedPanGesture(_ recognizer: UIPanGestureRecognizer) {
        shouldDismiss ? dismiss() : expand(nextState == .expanded)
        delegate?.bottomSheet(self, didEndPanGesture: recognizer)
    }

}

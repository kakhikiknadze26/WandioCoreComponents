//
//  WandioBottomSheet.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/19/20.
//

import UIKit

open class WandioBottomSheet: UIView {
    
    public var isPresented = false
    
    private let handleArea: UIView = DefaultHandlerView()
    private let contentView = UIView()
    public var backgroundView = UIView()
    
    internal var topConstraint: NSLayoutConstraint?
    internal var originalTopConstraintConstant: CGFloat = .zero
    
    public var maximumContentHeight: CGFloat?
    public var handleHeight: CGFloat? = 65
    internal var validContentHeight: CGFloat {
        contentView.layoutIfNeeded()
        if let maxHeight = maximumContentHeight {
            return min(maxHeight, contentView.frame.height)
        }
        return contentView.frame.height
    }
    internal var validHandleHeight: CGFloat {
        handleArea.layoutIfNeeded()
        return handleHeight ?? handleArea.frame.height
    }
    private var cardHeight: CGFloat {
        validHandleHeight + validContentHeight
    }
    
    public var hasBackground = true
    public var isExpanded = false
    internal var shouldDismiss = false
    private var nextState: CardState {
        isExpanded ? .collapsed : .expanded
    }
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        configureUI()
        addGestures()
    }
    
    // MARK: - Content
    open func addContent(_ content: UIView, at index: Int? = nil) {
        if let index = index {
            contentView.insertSubview(content, at: index)
        } else {
            contentView.addSubview(content)
        }
        content.stretchLayout()
    }
    
    // MARK: - UI
    private func configureUI() {
        backgroundColor = .clear
        setupBackgroundView()
        addHandleArea()
        addContentView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        //handleArea.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
    private func setupBackgroundView() {
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.4
    }
    
    private func addBackground(on view: UIView) {
        view.addSubview(backgroundView)
        backgroundView.frame = view.bounds
    }
    
    private func removeBackground(animated: Bool = true) {
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
    
    open func present(on viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        present(on: viewController.view, animated: animated, completion: completion)
    }
    
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
    
    private func addTopConstraintOnHandlerArea() {
        let height = bounds.height - cardHeight
        let constant: CGFloat = max(0, height - safeAreaInsets.top)
        originalTopConstraintConstant = constant
        topConstraint = handleArea.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: constant)
        topConstraint?.isActive = true
    }
    
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
    
}

// MARK: - Animations
extension WandioBottomSheet {
    
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
    
    private func animateDismiss(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.transform = CGAffineTransform(translationX: 0, y: self.superview?.frame.height ?? 0)
            self.backgroundView.alpha = 0
        } completion: { _ in
            self.isPresented = false
            self.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
            completion?()
        }
    }
    
    private func animateBackgroundViewRemove() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.backgroundView.alpha = 0
        } completion: { _ in
            self.backgroundView.removeFromSuperview()
            self.hasBackground = false
        }
    }
    
}

// MARK: - Content View
extension WandioBottomSheet {
    
    private func addContentView() {
        contentView.backgroundColor = .yellow
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
    
}

// MARK: - Handle Area
extension WandioBottomSheet {
    
    private func addHandleArea() {
        //handleArea.backgroundColor = .white
        addSubview(handleArea)
        setupHandleAreaConstraints()
    }
    
    private func setupHandleAreaConstraints() {
        handleArea.translatesAutoresizingMaskIntoConstraints = false
        handleArea.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor).isActive = true
        handleArea.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        handleArea.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        guard let handleHeight = handleHeight else { return }
        handleArea.heightAnchor.constraint(equalToConstant: handleHeight).isActive = true
    }
    
}

// MARK: - Handle Pull Up/Down
extension WandioBottomSheet {

    private enum CardState {
        case expanded, collapsed
    }
    
    private func addGestures() {
        backgroundView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.didTapBackground)))
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapBackground)))
        handleArea.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(recognizer:))))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:))))
    }

    @objc private func didTapBackground() {
        dismiss()
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
            guard !(isExpanded && translation.y < .zero) else { break }
            shouldDismiss = (translation.y > .zero && !isExpanded)
        case .changed:
            let newConstant = max(0, (topConstraint?.constant ?? 0) + translation.y)
            topConstraint?.constant = newConstant
            recognizer.setTranslation(.zero, in: self)
        case .ended:
            if shouldDismiss {
                dismiss()
            } else {
                expand(nextState == .expanded)
            }
        default:
            break
        }
    }
    
    private func expand(_ expand: Bool) {
        topConstraint?.constant = expand ? 0 : originalTopConstraintConstant
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.layoutIfNeeded()
        } completion: { _ in
            self.isExpanded.toggle()
        }
    }

}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct BottomSheetPreview: PreviewProvider {
    static var devices: [PreviewDevices] = [.iPhone8, .iPhone11ProMax]

    static var previews: some View {
        ForEach(devices.map{$0.string}, id: \.self) { deviceName in
            TestVC().toPreview().edgesIgnoringSafeArea(.all).previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
#endif

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        layoutIfNeeded()
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func stretchLayout() {
        guard let sv = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: sv.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: sv.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: sv.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: sv.bottomAnchor).isActive = true
    }
    
}

class TestView: UIView {
    
    let child = UIView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(child)
        child.backgroundColor = .clear
        child.translatesAutoresizingMaskIntoConstraints = false
        child.heightAnchor.constraint(equalToConstant: 600).isActive = true
        child.topAnchor.constraint(equalTo: topAnchor).isActive = true
        child.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        child.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        child.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.text = "Content"
        label.translatesAutoresizingMaskIntoConstraints = false
        child.addSubview(label)
        label.centerXAnchor.constraint(equalTo: child.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: child.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

class DefaultHandlerView: RoundedShadowedView {
    
    let handler = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = .white
        addHandler()
        shadowColor = .black
        shadowAlpha = 0.6
        shadowRadius = 10
        shadowOffset = CGSize(width: 0, height: -10)
        roundingCorners = [.topLeft, .topRight]
        cornerRadius = 20
    }
    
    private func addHandler() {
        handler.backgroundColor = .lightGray
        addSubview(handler)
        handler.translatesAutoresizingMaskIntoConstraints = false
        handler.heightAnchor.constraint(equalToConstant: 8 * screenFactor).isActive = true
        handler.widthAnchor.constraint(equalToConstant: 80 * screenFactor).isActive = true
        handler.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        handler.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        handler.layoutIfNeeded()
        handler.layer.cornerRadius = handler.bounds.height/2
        handler.clipsToBounds = true
    }
    
}

public class TestVC: UIViewController {
    
    let sheet = WandioBottomSheet()
    let button = UIButton(frame: CGRect(x: 40, y: 100, width: 100, height: 100))
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        button.setTitle("Press Me", for: .normal)
        button.addTarget(self, action: #selector(self.buttonTap), for: .touchUpInside)
        view.addSubview(button)
        view.backgroundColor = .orange
        let test = TestView()
        test.backgroundColor = .white
        sheet.addContent(test)
        sheet.present(on: self, animated: true, completion: nil)
    }
    
    @objc private func buttonTap() {
        button.setTitle("\(Int.random(in: 0...10))", for: .normal)
        sheet.present(on: self, animated: true, completion: nil)
    }
    
}
//============================================================================================================

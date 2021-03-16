//
//  ModalVC.swift
//  AnimationDemo
//
//  Created by Adriana González Martínez on 3/14/21.
//

import UIKit

private enum State{
    case open
    case closed
    
    var opposite: State{
        switch self {
        case .open: return .closed
        case .closed: return.open
        }
    }
}

class ModalVC: UIViewController {
    
    var modalView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.purple
        return view
    }()
    
    var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    

    private var bottomConstraint: NSLayoutConstraint!
    private var modalHeight: CGFloat! = 400
    private var visibleHeight: CGFloat = 70
    private var currentState: State = .closed

    var transitionAnimator: UIViewPropertyAnimator!
    private var animationProgress : CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
      
        view.addSubview(overlayView)
        overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        overlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        view.addSubview(modalView)
        modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        modalView.heightAnchor.constraint(equalToConstant: modalHeight).isActive = true
        bottomConstraint = modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: modalHeight - visibleHeight)
        bottomConstraint.isActive = true
        
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(viewPanned(recognizer:)))
        modalView.addGestureRecognizer(recognizer)
        modalView.isUserInteractionEnabled = true

    }
   
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
   
        // an animator for the transition
        transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = self.modalHeight - self.visibleHeight
            }
            self.view.layoutIfNeeded()
        })
        
        // the transition completion block
        transitionAnimator.addCompletion { position in
            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            @unknown default:
                fatalError()
            }
            
            // manually reset the constraint positions
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = self.modalHeight - self.visibleHeight
            }
            
        }
    
        // start animator
        transitionAnimator.startAnimation()

    }
    
    @objc private func viewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            
            // start the animation
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1)
            
            // pause, since the next event may be a pan changed
            transitionAnimator.pauseAnimation()
            
            // keep track of progress
            animationProgress = transitionAnimator.fractionComplete
            
        case .changed:
            
            let translation = recognizer.translation(in: modalView)
            var fraction = -translation.y / (self.modalHeight - self.visibleHeight)
            
            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 }
            if transitionAnimator.isReversed { fraction *= -1 }
            
            // apply the new fraction
            transitionAnimator.fractionComplete = fraction + animationProgress
               
            
        case .ended:
            
            let yVelocity = recognizer.velocity(in: modalView).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, animation and exit early
            if yVelocity == 0 {
                transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            
            // reverse the animation based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !transitionAnimator.isReversed { transitionAnimator.isReversed = !transitionAnimator.isReversed }
                if shouldClose && transitionAnimator.isReversed {  transitionAnimator.isReversed = !transitionAnimator.isReversed }
            case .closed:
                if shouldClose && !transitionAnimator.isReversed { transitionAnimator.isReversed = !transitionAnimator.isReversed }
                if !shouldClose && transitionAnimator.isReversed { transitionAnimator.isReversed = !transitionAnimator.isReversed }
            }
            transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            ()
        }
    }
}

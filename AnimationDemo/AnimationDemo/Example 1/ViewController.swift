//
//  ViewController.swift
//  AnimationDemo
//
//  Created by Adriana González Martínez on 3/14/21.
//

import UIKit

class ViewController: UIViewController {
    
    //Properties
    var animator = UIViewPropertyAnimator()
    var movementInX: CGFloat!
    @IBOutlet weak var exampleView: UIView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //Defining the amount of points to move
        movementInX =  self.view.frame.size.width - 40
        //Creating the pan gesture
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(handlePan(recognizer:)))
        //Adding the gesture to the view we want to move
        exampleView.addGestureRecognizer(recognizer)
    }

    //Function that handles the state of the animation
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            //The user starts interacting with the view
            //Defining the animation, what are the changes applied to the view
            animator = UIViewPropertyAnimator(duration: 3, curve: .easeOut, animations: {
                self.exampleView.transform = CGAffineTransform(translationX: self.movementInX, y: 0)
                self.exampleView.alpha = 0
            })
            //Animation starts
            animator.startAnimation()
            //But we pause it immediately so that it changes state
            animator.pauseAnimation()
        case .changed:
            //We can modify the fractionComplete value in relation to where our finger is in the X axis
            animator.fractionComplete = recognizer.translation(in: self.exampleView).x / movementInX
        case .ended:
            //If we let go, the animation continues on its own
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            ()
        }
    }
}


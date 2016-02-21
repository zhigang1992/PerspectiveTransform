//
//  ViewController.swift
//  PerspectiveTransform
//
//  Created by Paul Zabelin on 02/18/2016.
//  Copyright (c) 2016 Paul Zabelin. All rights reserved.
//

import UIKit
import QuartzCore

@testable import PerspectiveTransform

class ViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet var cornerViews: [UIView]!
    @IBOutlet weak var transView: UIView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var destView: UIView!

    // MARK: - UIViewController

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        anchorAtZeroPoint()
        updatePosition()
    }

    @IBAction func didPan(recognizer: UIPanGestureRecognizer) {
        let controlPoint = recognizer.view!
        let translation = recognizer.translationInView(controlPoint.superview)
        let transform = CGAffineTransformMakeTranslation(translation.x, translation.y)
        controlPoint.center = CGPointApplyAffineTransform(controlPoint.center, transform)
        recognizer.setTranslation(CGPointZero, inView:controlPoint.superview)
        updatePosition()
    }


    // MARK: - private

    func anchorAtZeroPoint() {
        let rect = transView.frame
        transView.layer.anchorPoint = CGPointZero
        transView.frame = rect
    }

    func updatePosition() {
        let centers = cornerViews.map{$0.center}
        let quad = Quadrilateral(centers)
        let start = Quadrilateral(startView.frame)
        let projection = general2DProjection(start, to: quad)
        let expanded = expandNoZ(expandNoZ(projection))
        let transform3D = transform(expanded)
        transView.layer.transform = transform3D
    }
}


//
//  GraphView.swift
//  UsingDataGraphFramework
//
//  Created by Owen Hildreth on 12/19/21.
//

import Foundation
import SwiftUI

class GraphView: NSView {
    var graphController: GraphController? = nil

    private var graphView: DPDrawingView = DPDrawingView()
    
    convenience init(_ graphControllerIn: GraphController) {
        let newFrame = NSRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100.0, height: 100.0))
        self.init(frame: newFrame)
        
        
        graphController = graphControllerIn
        
        //graph = DPDrawingView()
        
        graphView = DPDrawingView()
        graphView.frame = newFrame
        graphView.autoresizingMask = [.width, .height]
        
        self.addSubview(graphView)
        graphController?.dgController?.setDrawingView(graphView)
        
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




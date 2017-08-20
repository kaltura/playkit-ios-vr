// ===================================================================================================
// Copyright (C) 2017 Kaltura Inc.
//
// Licensed under the AGPLv3 license, unless a different license for a
// particular library is specified in the applicable library path.
//
// You may obtain a copy of the License at
// https://www.gnu.org/licenses/agpl-3.0.html
// ===================================================================================================

import Foundation
import AVFoundation
import AVKit
import PlayKit
import NYT360Video

class VRPlayerWrapper: AVPlayerWrapper, VRPlayerEngine {
    var nyt360VC: NYT360ViewController!
   
    required init(delegate: PlayerDelegate?) {
        super.init()
        // Create a VRViewController
        self.createVRPlayerViewController(delegate: delegate)
    }
    
    func createVRPlayerViewController(delegate: PlayerDelegate?) {
        // Create a NYT360ViewController with the AVPlayer and our app's motion manager:
        let manager = NYT360MotionManager.shared()
        
        self.nyt360VC = NYT360ViewController(avPlayer: self.currentPlayer, motionManager: manager!)
        
        guard let playerDelegate = delegate else {
            PKLog.warning("playerDelegate is nil")
            return
        }
        
        playerDelegate.shouldAddPlayerViewController?(self.nyt360VC)
    }
}

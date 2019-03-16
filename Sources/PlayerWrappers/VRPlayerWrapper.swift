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
import MetalScope
import SceneKit

class VRPlayerWrapper: AVPlayerWrapper, VRPlayerEngine {
    /************************************************************/
    // MARK: - Properties
    /************************************************************/
    
    weak var panoramaView: PanoramaView?
    weak var stereoView: StereoView?
    var currentViewState: ViewState = ViewState.unknown {
        didSet {
            PKLog.info("ViewState was updated to: \(currentViewState) from: \(oldValue)")
        }
    }
    var orientationIndicator: OrientationIndicatorView?
    
    lazy var device: MTLDevice = {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Failed to create MTLDevice")
        }
        
        return device
    }()
    
    /************************************************************/
    // MARK: - Initialization
    /************************************************************/
    required override init() {
        super.init()
    }
    
    /************************************************************/
    // MARK: - Functions
    /************************************************************/    
    
    /// Panora View preparation as default view
    /// Supports 360 video
    private func preparePanoramaView() {
        loadPanoramaView()
        loadPlayerOnPanoramaView()
    }
    
    /// PanoramaView Creation and attachment as subview on VRViewController
    private func loadPanoramaView() {
        // Since self.panoramaView is weak
        // Using let panoramaView till self.panoramaView attached to view hierarchy.
        let panoramaView: PanoramaView
        
        guard let playerView = view else {
            PKLog.error("Player view is nil.")
            return
        }
        
        // Metal has limited functionality on the simulator.
        // PanoramaView can display photos, but cannot display videos on simulator.
        #if arch(arm) || arch(arm64)
            PKLog.debug("PanoramaView creation on device")
            panoramaView = PanoramaView(frame: playerView.bounds, device: device)
        #else
            PKLog.debug("PanoramaView creation on simulator")
            panoramaView = PanoramaView(frame: playerView.bounds)
        #endif
        
        // Panorama View Attachment on VRViewController.
        panoramaView.translatesAutoresizingMaskIntoConstraints = false
        
        playerView.addSubview(panoramaView)
        // Update currentViewState to poanorama
        self.currentViewState = ViewState.panorama
        
        // Fill parent view
        let constraints: [NSLayoutConstraint] = [
            panoramaView.topAnchor.constraint(equalTo: playerView.topAnchor),
            panoramaView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            panoramaView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
            panoramaView.trailingAnchor.constraint(equalTo: playerView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        self.panoramaView = panoramaView
    }
    
    /// Load PlayKit Player (AVPlayer) on panorama view
    private func loadPlayerOnPanoramaView() {
        // Metal has limited functionality on the simulator.
        #if arch(arm) || arch(arm64)
            PKLog.info("Loading AVPlayer into PanoramaView")
            guard let panorama = self.panoramaView else {
                PKLog.debug("panoramaView is nil.")
                
                return
            }
            
            panorama.load(self.currentPlayer, format: .mono)
        #else
            fatalError("PlayKit can't play 360 video on simulator, please move to device.")
        #endif
    }
    
    private func loadStereoView() {
        // Since self.stereoView is weak
        // Using let stereoView till self.stereoView attached to view hierarchy.
        let stereoView: StereoView
        
        guard let playerView = view else {
            PKLog.error("Player view is nil.")
            return
        }
        
        // Metal has limited functionality on the simulator.
        // PanoramaView can display photos, but cannot display videos on simulator.
        #if arch(arm) || arch(arm64)
            PKLog.debug("StereoView creation on device")
            stereoView = StereoView(device: device)
        #else
            PKLog.debug("StereoView creation on simulator")
            stereoView = StereoView()
        #endif
        
        // Panorama View Attachment on VRViewController.
        stereoView.translatesAutoresizingMaskIntoConstraints = false
        
        playerView.addSubview(stereoView)

        // Update currentViewState to poanorama
        self.currentViewState = ViewState.stereo
        
        // Fill parent view
        let constraints: [NSLayoutConstraint] = [
            stereoView.topAnchor.constraint(equalTo: playerView.topAnchor),
            stereoView.bottomAnchor.constraint(equalTo: playerView.bottomAnchor),
            stereoView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
            stereoView.trailingAnchor.constraint(equalTo: playerView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        self.stereoView = stereoView
    }
    
    private func presentPanoramaView() {
        // Remove StereoView from view hierarchy
        self.stereoView?.removeFromSuperview()
        // Create PanoramaView and add to view hierarchy
        self.loadPanoramaView()
        // Pass SCNScene to PanoramaView
        self.panoramaView?.scene = self.stereoView?.scene
        // Reset SCNScene on StereoView
        self.stereoView?.scene = nil
    }

    private func presentStereoView() {
        // Remove PanoramaView from view hierarchy
        self.panoramaView?.removeFromSuperview()
        // Create StereoView and add to view hierarchy
        self.loadStereoView()
        // Pass SCNScene to StereoView
        self.stereoView?.scene = self.panoramaView?.scene
        // Reset SCNScene on PanoramaView
        self.panoramaView?.scene = nil
    }
    
    /************************************************************/
    // MARK: - AVPlayerWrapper Methods Override
    /************************************************************/
    
    override func loadMedia(from mediaSource: PKMediaSource?, handler: AssetHandler) {
        super.loadMedia(from: mediaSource, handler: handler)
        self.preparePanoramaView()
    }
    
    override func destroy() {
        PKLog.debug("Remove all view from view hierarchy")
        self.panoramaView?.removeFromSuperview()
        self.stereoView?.removeFromSuperview()
        super.destroy()
    }
    
    /************************************************************/
    // MARK: - VRPlayerEngine Implementation
    /************************************************************/
    
    func setVRModeEnabled(_ isEnabled: Bool) {
        PKLog.debug("isEnabled: \(isEnabled)")
        
        if isEnabled && self.currentViewState != ViewState.stereo  {
            PKLog.debug("presentStereoView")
            self.presentStereoView()
        } else if self.currentViewState != ViewState.panorama {
            PKLog.debug("presentPanoramaView")
            self.presentPanoramaView()
        }
    }
    
    func centerViewPoint() {
        PKLog.debug("setNeedsResetRotation")
        self.panoramaView?.setNeedsResetRotation()
    }

    func createOrientationIndicatorView(frame: CGRect) -> UIView? {
        self.orientationIndicator = OrientationIndicatorView(frame: frame)
        
        self.orientationIndicator?.dataSource = self.panoramaView
        
        if (self.orientationIndicator != nil) {
            self.panoramaView?.sceneRendererDelegate = self
        }
        
        PKLog.debug("orientationIndicator was created")
        return self.orientationIndicator
    }
}

/************************************************************/
// MARK: - Extensions
/************************************************************/

extension VRPlayerWrapper: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // please make sure to update the indicator on main thread
        DispatchQueue.main.async { [weak self] in
            PKLog.debug("updateOrientation")
            self?.orientationIndicator?.updateOrientation()
        }
    }
}

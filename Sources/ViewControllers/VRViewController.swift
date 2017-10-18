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
import PlayKit

class VRViewController: UIViewController {
    override func viewDidLoad() {
        PKLog.debug("VRViewController did load")
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        PKLog.debug("VRViewController did appear")
        super.viewDidAppear(animated)
    }
    
    override func removeFromParentViewController() {
        PKLog.debug("VRViewController was removed from Parent View Controller")
        super.removeFromParentViewController()
    }
}

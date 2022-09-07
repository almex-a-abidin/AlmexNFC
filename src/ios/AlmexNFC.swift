/********* AlmexNFC.m Cordova Plugin Implementation *******/

import CDVPlugin
import UIKit
import CoreNFC

@objc(AlmexNFC) class  AlmexNFC : CDVPlugin {
  var pluginResult =  CDVPluginResult(status: CDVCommandStatus_ERROR)
   var ndefController: AlmexNFCDelegate?

  override func pluginInitialize() {

  }

  @objc(scan:)
  func scan(_ command: CDVInvokedUrlCommand?) -> [AnyHashable: Any]? {
    if self.ndefController == nil {
        self.ndefController = AlmexNFCDelegate(completed: { (response: [AnyHashable: Any]?, error: Error?) -> Void in
            return response
        }, message: {

        });
    }

    return nil
  }

}



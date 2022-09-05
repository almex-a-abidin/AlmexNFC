
import Foundation
import CoreNFC

class AlmexNFCDelegate: NSObject, NFCNDEFReaderSessionDelegate {
    var session: NFCNDEFReaderSession?
    var completed: ([AnyHashable : Any]?, Error?) -> ()
    
    init(completed: @escaping ([AnyHashable: Any]?, Error?) -> (), message: String?) {
        self.completed = completed

        if !NFCNDEFReaderSession.readingAvailable {
            self.completed(nil, "NFC is not available" as? Error)
        }

        self.session = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.begin()
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        self.completed(nil, error)
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            self.completed(message.ndefMessageToJSON, nil)
        }

        self.session?.invalidate()
    }
}

extension AlmexNFCDelegate {
    func ndefMessageToJSON() -> [AnyHashable: Any] {
        let array = NSMutableArray()
        for record in self.records {
            let recordDictionary = self.ndefToNSDictionary(record: record)
            array.add(recordDictionary)
        }
        let wrapper = NSMutableDictionary()
        wrapper.setObject(array, forKey: "ndefMessage" as NSString)
        
        let returnedJSON = NSMutableDictionary()
        returnedJSON.setValue("ndef", forKey: "type")
        returnedJSON.setObject(wrapper, forKey: "tag" as NSString)

        return returnedJSON as! [AnyHashable : Any]
    }
    
    func ndefToNSDictionary(record: NFCNDEFPayload) -> NSDictionary {
        let dict = NSMutableDictionary()
        dict.setObject([record.typeNameFormat.rawValue], forKey: "tnf" as NSString)
        dict.setObject([UInt8](record.type), forKey: "type" as NSString)
        dict.setObject([UInt8](record.identifier), forKey: "id" as NSString)
        dict.setObject([UInt8](record.payload), forKey: "payload" as NSString)
        
        return dict
    }
    
}
//
//  CloudPlaygroundItem.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 23/10/2021.
//

#if DEBUG
import SwiftUI
import CloudKit

struct CloudPlaygroundItem: View {
    let recordValue: __CKRecordObjCValue?
    let maxWidth: CGFloat

    var body: some View {
        Text(stringValue)
            .frame(maxWidth: maxWidth)
            .lineLimit(1)
    }

    private var stringValue: String {
        if let recordString = recordValue as? String {
            return recordString
        } else if let recordDate = recordValue as? Date {
            return Self.dateFormatter.string(from: recordDate)
        } else if let recordNumber = recordValue as? NSNumber {
            return recordNumber.stringValue
        }
        return ""
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

//struct CloudPlaygroundItem_Previews: PreviewProvider {
//    static var previews: some View {
//        CloudPlaygroundItem()
//    }
//}
#endif

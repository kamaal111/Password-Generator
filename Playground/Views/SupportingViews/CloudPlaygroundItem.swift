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
    let mask: Bool
    let width: CGFloat
    let isHighlighted: Bool

    var body: some View {
        VStack {
            Text(stringValue)
                .lineLimit(1)
                .foregroundColor(isHighlighted ? .accentColor : .primary)
                .frame(minWidth: width, maxWidth: width)
            Divider()
        }

    }

    private var stringValue: String {
        let value: String
        if let recordString = recordValue as? String {
            value = recordString
        } else if let recordDate = recordValue as? Date {
            value = Self.dateFormatter.string(from: recordDate)
        } else if let recordNumber = recordValue as? NSNumber {
            value = recordNumber.stringValue
        } else {
            value = ""
        }
        if !mask {
            return value
        }
        return value.map({ _ in "*" }).joined(separator: "")
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

// struct CloudPlaygroundItem_Previews: PreviewProvider {
//    static var previews: some View {
//        CloudPlaygroundItem()
//    }
// }
#endif

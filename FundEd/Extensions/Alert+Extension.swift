//
//  Alert+Extension.swift
//  FundEd
//
//  Created by Yemi Gabriel on 3/6/22.
//

import SwiftUI

extension Alert {
    init(title: String, message: String?) {
        self = Alert(title: Text(title), message: Text(message ?? ""), dismissButton: .default(Text("OK")))
    }
    
    init(title: String, message: String?, dismissAction: @escaping ()->Void) {
        self = Alert(title: Text(title), message: Text(message ?? ""), dismissButton: .default(Text("OK"), action: dismissAction))
    }
    
    init(title: String, message: String?, primaryButtonTitle: String, secondaryButtonTitle: String, primaryAction: @escaping ()->Void, secondaryAction: @escaping ()->Void) {
        self = Alert(title: Text(title),
                     message: Text(message ?? ""),
                     primaryButton: .default(Text(primaryButtonTitle), action: primaryAction),
                     secondaryButton: .default(Text(secondaryButtonTitle), action: secondaryAction ))
    }
}

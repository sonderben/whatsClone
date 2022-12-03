//
//  Util.swift
//  whatsClone
//
//  Created by Benderson Phanor on 19/8/22.
//

import Foundation
import SwiftUI
import FirebaseAuth



private struct IsUserConectedKey: EnvironmentKey {
    static let defaultValue: Bool = false
}
extension EnvironmentValues {
    var isUserConected: Bool {
        get { self[IsUserConectedKey.self] }
        set { self[IsUserConectedKey.self] = newValue }
    }
}




struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}



extension Date{
    var dateFormaterHourMin: DateFormatter{
        let formater=DateFormatter()
        formater.dateStyle = .none
        formater.timeStyle = .short
        return formater
    }
    var DateFormatterDayHourMin: DateFormatter{
        let formater=DateFormatter()
        formater.doesRelativeDateFormatting = true
        formater.dateStyle = .short
        formater.timeStyle = .short
        return formater
    }
    
    var dateFormater: DateFormatter{
        let formater=DateFormatter()
        formater.dateStyle = .long
        formater.timeStyle = .long
        return formater
    }
    var dateFormater2: DateFormatter{
        let formater=DateFormatter()
        formater.dateStyle = .long
        formater.timeStyle = .none
        return formater
    }
    
    var dateFormater3: DateFormatter{
        let formatter=DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    var dateFormater4: DateFormatter{
        let formatter=DateFormatter()
        //formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    func prettyShort(includeHour a :Bool=false)->String{
        return dateFormater4.string(from: self)
    }
    func pretty(includeHour a :Bool=false)->String{
        if a {
            return dateFormater.string(from: self)
        }
        return dateFormater2.string(from: self)
    }
    func prettyMedium(includeHour a :Bool=false)->String{
        if a {
            return dateFormater.string(from: self)
        }
        return dateFormater3.string(from: self)
    }
    func prettyHM()->String{
        
        return dateFormaterHourMin.string(from: self)
    }
    func prettyDHM_RD()->String{
        
        return DateFormatterDayHourMin.string(from: self)
    }
}


extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

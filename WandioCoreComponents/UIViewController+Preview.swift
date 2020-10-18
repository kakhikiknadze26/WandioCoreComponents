//
//  UIViewController+Preview.swift
//  ReactiveNetworking
//
//  Created by Kakhi Kiknadze on 10/11/20.
//

import UIKit

#if DEBUG
import SwiftUI

@available(iOS 13, *)
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        // this variable is used for injecting the current view controller
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func toPreview() -> some View {
        // inject self (the current view controller) for the preview
        Preview(viewController: self)
    }
}

extension UIView {
    private struct Preview: UIViewRepresentable {
        let view: UIView
        
        func makeUIView(context: Context) -> some UIView {
            return view
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {
            
        }
    }
    
    func toPreview() -> some View {
        // inject self (the current view controller) for the preview
        Preview(view: self)
    }
}
#endif

enum PreviewDevices: CaseIterable {
    case iPhone8
    case iPhone8Plus
    case iPhoneSE
    case iPhoneSE2
    case iPhone11
    case iPhone11Pro
    case iPhone11ProMax
    case iPadMini4
    case iPadAir2
    case iPadPro9p7Inch
    case iPadPro12p9Inch
    case iPad5thGeneration
    case iPadPro12p9Inch2ndGeneration
    case iPadPro10p5Inch
    case iPad6thGeneration
    case iPadPro11Inch
    case iPadPro12p9Inch3rdGeneration
    case iPadMini5thGeneration
    case iPadAir3rdGeneration
    case appleTV
    case appleTV4K
    case appleTV4Kat1080p
    case appleWatchSeries2_38mm
    case appleWatchSeries2_42mm
    case appleWatchSeries3_38mm
    case appleWatchSeries3_42mm
    case appleWatchSeries4_40mm
    case appleWatchSeries4_44mm
    
    var string: String {
        switch self {
        case .iPhone8:
            return "iPhone 8"
        case .iPhone8Plus:
            return "iPhone 8 Plus"
        case .iPhoneSE:
            return "iPhone SE"
        case .iPhoneSE2:
            return "iPhone SE (2nd Generation)"
        case .iPhone11:
            return "iPhone 11"
        case .iPhone11Pro:
            return "iPhone 11 Pro"
        case .iPhone11ProMax:
            return "iPhone 11 Pro Max"
        case .iPadMini4:
            return "iPad mini 4"
        case .iPadAir2:
            return "iPad Air 2"
        case .iPadPro9p7Inch:
            return "iPad Pro (9.7-inch)"
        case .iPadPro12p9Inch:
            return "iPad Pro (12.9-inch)"
        case .iPad5thGeneration:
            return "iPad (5th generation)"
        case .iPadPro12p9Inch2ndGeneration:
            return "iPad Pro (12.9-inch) (2nd generation)"
        case .iPadPro10p5Inch:
            return "iPad Pro (10.5-inch)"
        case .iPad6thGeneration:
            return "iPad (6th generation)"
        case .iPadPro11Inch:
            return "iPad Pro (11-inch)"
        case .iPadPro12p9Inch3rdGeneration:
            return "iPad Pro (12.9-inch) (3rd generation)"
        case .iPadMini5thGeneration:
            return "iPad mini (5th generation)"
        case .iPadAir3rdGeneration:
            return "iPad Air (3rd generation)"
        case .appleTV:
            return "Apple TV"
        case .appleTV4K:
            return "Apple TV 4K"
        case .appleTV4Kat1080p:
            return "Apple TV 4K (at 1080p)"
        case .appleWatchSeries2_38mm:
            return "Apple Watch Series 2 - 38mm"
        case .appleWatchSeries2_42mm:
            return "Apple Watch Series 2 - 42mm"
        case .appleWatchSeries3_38mm:
            return "Apple Watch Series 3 - 38mm"
        case .appleWatchSeries3_42mm:
            return "Apple Watch Series 3 - 42mm"
        case .appleWatchSeries4_40mm:
            return "Apple Watch Series 4 - 40mm"
        case .appleWatchSeries4_44mm:
            return "Apple Watch Series 4 - 44mm"
        }
    }
}

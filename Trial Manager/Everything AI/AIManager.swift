//
//  AIManager.swift
//  Trial Manager
//
//  Created by Milind Contractor on 23/1/26.
//

import FoundationModels
import Foundation

struct AIAvailabilityInformation {
    var availability: Bool
    var reasonForNotWorking: String?
    var deviceDoesntSupportFeature: Bool = false
}

func getInfoToShowView() -> Bool {
    switch SystemLanguageModel.default.availability {
    case .available:
        return true
    case .unavailable(let reason):
        switch reason {
        case .appleIntelligenceNotEnabled:
            return true
        case .deviceNotEligible:
            return false
        case .modelNotReady:
            return true
        @unknown default:
            return true
        }
    }
}

func checkAIAvailability() -> AIAvailabilityInformation {
    switch SystemLanguageModel.default.availability {
    case .available:
        return AIAvailabilityInformation(availability: true)
    case .unavailable(let reason):
        switch reason {
        case .appleIntelligenceNotEnabled:
            return AIAvailabilityInformation(availability: false, reasonForNotWorking: "Apple Intelligence has not been enabled on your device. For this feature to work, please enable it in Settings")
        case .deviceNotEligible:
            return AIAvailabilityInformation(availability: false, reasonForNotWorking: "Your device does not support Apple Intelligence", deviceDoesntSupportFeature: true)
        case .modelNotReady:
            return AIAvailabilityInformation(availability: false, reasonForNotWorking: "The Apple Intelligence language model is not ready yet, which is required for financial summaries to work. Please try again later.")
        @unknown default:
            return AIAvailabilityInformation(availability: false, reasonForNotWorking: "The language model required for financial summaries is not available for an unknown reason. Please try again later.")
        }
    }
}

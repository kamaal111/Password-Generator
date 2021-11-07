//
//  ScreenModel.swift
//  Password-Generator
//
//  Created by Kamaal M Farah on 05/09/2021.
//

import Foundation
import ShrimpExtensions
import ConsoleSwift
import PGLocale
#if canImport(UIKit)
import UIKit
#endif

struct ScreenModel: Hashable, Identifiable, Codable {
    let id: UUID
    let title: String
    let systemImage: String
    let navigationPoint: NamiNavigator.NavigationStacks?
    let excludedPlatforms: [ExcludedPlatforms]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case systemImage = "system_image"
        case navigationPoint = "navigation_point"
        case excludedPlatforms = "excluded_platforms"
    }

    enum ExcludedPlatforms: String, Codable {
        case macOS
        case iPhone
        case iPad
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        let titleString = try container.decode(String.self, forKey: .title)
        self.title = PGLocale.Keys(rawValue: titleString)?.localized ?? titleString
        self.systemImage = try container.decode(String.self, forKey: .systemImage)
        self.navigationPoint = try? container.decode(NamiNavigator.NavigationStacks.self, forKey: .navigationPoint)
        self.excludedPlatforms = try? container.decode([ExcludedPlatforms].self, forKey: .excludedPlatforms)
    }

    var isNotExcluded: Bool {
        guard let excludedPlatforms = excludedPlatforms else { return true }
        let currentPlatform: ExcludedPlatforms
        #if os(iOS)
        if DeviceInfo.isIpad {
            currentPlatform = .iPad
        } else {
            currentPlatform = .iPhone
        }
        #else
        currentPlatform = .macOS
        #endif
        return !excludedPlatforms.contains(currentPlatform)
    }

    static func decodeFromJSON(withFileName fileName: String) -> [ScreenModel] {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else { return [] }
        let url = URL(fileURLWithPath: path)
        let result: Result<[ScreenModel], Error> = url.decodeJSON()
        switch result {
        case .failure(let failure):
            console.error(Date(), failure.localizedDescription, failure)
            return []
        case .success(let success): return success
        }
    }
}

//
//  CSVParser.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 08.02.2025.
//


import Foundation

extension Locale {

   public var countryNames: [String] {
      return Locale.countryNames(for: self)
   }

   public static func countryNames(for locale: Locale) -> [String] {
      let nsLocale = locale as NSLocale
      let result: [String] = NSLocale.isoCountryCodes.compactMap {
         return nsLocale.displayName(forKey: .countryCode, value: $0)
      }
      // Seems `isoCountryCodes` already sorted. So, we skip sorting.
      return result
   }
}

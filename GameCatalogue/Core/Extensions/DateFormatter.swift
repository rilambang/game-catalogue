//
//  DateFormatter.swift
//  GameCatalogue
//
//  Created by Muhammad Ilham Rilambang on 04/04/23.
//

import Foundation

func changeDateFormat(_ date: String,
                      inputFormat: String = "yyyy-MM-dd",
                      outputFormat: String = "dd-MM-yyyy") -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = inputFormat
    guard let showDate = dateFormatter.date(from: date) else {
        return nil
    }
    dateFormatter.dateFormat = outputFormat
    let resultString = dateFormatter.string(from: showDate)
    return resultString
}

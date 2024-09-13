//
//  MockData.swift
//  Tracker
//
//  Created by Roman Romanov on 09.09.2024.
//

import Foundation

extension TrackerCategory {
    static let mockData = [
        TrackerCategory(
            title: "Важное",
            trackerList: []
        ),
        TrackerCategory(
            title: "Важное 2",
            trackerList: [
                Tracker(
                    name: "что-то такое",
                    color: AppColorSettings.palette[3],
                    emoji: AppEmojis[0],
                    schedule: [WeekDay.monday]
                ),
                Tracker(
                    name: "что-то НЕ такое",
                    color: AppColorSettings.palette[6],
                    emoji: AppEmojis[6],
                    schedule: [WeekDay.monday]
                )
            ]
        ),
        TrackerCategory(
            title: "Лапша",
            trackerList: [
                Tracker(
                    name: "вилка",
                    color: AppColorSettings.palette[4],
                    emoji: AppEmojis[3],
                    schedule: [WeekDay.monday]
                ),
                Tracker(
                    name: "вермишелька",
                    color: AppColorSettings.palette[9],
                    emoji: AppEmojis[9],
                    schedule: [WeekDay.monday]
                ),
                Tracker(
                    name: "бульончик",
                    color: AppColorSettings.palette[2],
                    emoji: AppEmojis[13],
                    schedule: [WeekDay.tuesday]
                )
            ]
        )
    ]
    
}

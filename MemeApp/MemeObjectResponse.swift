//
//  MemeObjectResponse.swift
//  MemeApp
//
//  Created by Azam Mukhtar on 08/03/20.
//  Copyright © 2020 Azam Mukhtar. All rights reserved.
//

import Foundation

class MemeObjectResponse: Codable {
    let postLink: String
    let subreddit, title: String
    let url: String
}

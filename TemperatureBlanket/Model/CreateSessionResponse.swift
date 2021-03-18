//
//  CreateSessionResponse.swift
//  Moviefy
//
//  Created by Angelina Olmedo on 5/6/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import Foundation

struct CreateSessionResponse: Codable {
    let success: Bool
    let session_id: String
}

//
//  Model.swift
//  DeveloperStorageSaver
//
//  Created by Niclas Jeppsson on 16/03/2023.
//

import SwiftUI

struct StorageSize: Hashable {

    let directory: StorageDirectory
    var size: String
    var loadingState: LoadingState = .loading
}

//
//  ProfileRequest.swift
//  FakeNFT
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? { URL(string: Constants.endpointURLString + Constants.profilePathComponentString) }
}

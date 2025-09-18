struct CartUpdateDto: Dto {
    let nfts: [String]
    
    func asDictionary() -> [String: String] {
        
        var dict: [String: String] = [:]
        for (index, nft) in nfts.enumerated() {
            dict["nfts[\(index)]"] = nft
        }
        return dict
    }
}

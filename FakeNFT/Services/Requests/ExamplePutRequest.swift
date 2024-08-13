import Foundation

struct ExamplePutRequest: NetworkRequest {
   var endpoint: URL? {
       URL(string: "\(RequestConstants.baseURL)/api/v1/someMethod")
   }
   var httpMethod: HttpMethod = .put
   var dto: Dto?
}

struct ExampleDtoObject: Dto {
   let param1: String
   let param2: String

    enum CodingKeys: String, CodingKey {
        case param1 = "param_1" //имя поля в запросе будет param_1
        case param2 //имя поля в запросе будет param_2
    }

    func asDictionary() -> [String : String] {
        [
            CodingKeys.param1.rawValue: param1,
            CodingKeys.param2.rawValue: param2
        ]
    }
}

struct ExamplePutResponse: Decodable {
    let name: String
    let devices: [String]
}

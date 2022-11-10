import Vapor
import Fluent

//class FoodChoice {
//    var user: User?
//    var name: String
//    var labels: [String]
//    var timeCreated: Date
//
//    init(name: String, labels: [String], timeCreated: Date) {
//
//    }
//}

protocol FoodChoice: Model, Content {
    var user: User {get set}
    var name: String {get set}
    var labels: [String] {get set}
    var timeCreated: Date {get set}
}

protocol ThirdPartyContent {
    var srcURL: String {get set}
    var platform: String {get set}
}

protocol MerchantContent {
    var location: CodableLocation {get set}
    var address: USAddress {get set}
    var phone: String {get set}
}

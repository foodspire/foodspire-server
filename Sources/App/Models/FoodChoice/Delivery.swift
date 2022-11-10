import Fluent
import Vapor


final class Delivery: FoodChoice, ThirdPartyContent, MerchantContent {
    static let schema = "delivery"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "labels")
    var labels: [String]

    @Field(key: "timeCreated")
    var timeCreated: Date

    @Field(key: "srcURL")
    var srcURL: String
    
    @Field(key: "platform")
    var platform: String
    
    @Field(key: "location")
    var location: CodableLocation
    
    @Field(key: "address")
    var address: USAddress

    init() {}
}

extension Delivery {
    struct Migration: AsyncMigration {
        var name: String { "CreateDelivery" }

        func prepare(on database: Database) async throws {
            try await database.schema("delivery")
                .id()
                .field("name", .string, .required)
                .field("labels", .array(of: .string), .required)
                .field("timeCreated", .datetime, .required)
                .field("srcURL", .string, .required)
                .field("platform", .string, .required)
                .field("location", .dictionary, .required)
                .field("address", .dictionary, .required)
                .unique(on: "srcURL")
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("delivery").delete()
        }
    }
}

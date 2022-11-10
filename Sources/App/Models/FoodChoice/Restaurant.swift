import Fluent
import Vapor


final class Restaurant: FoodChoice, ThirdPartyContent, MerchantContent {
    static let schema = "restaurant"

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

    init(id: UUID? = nil, name: String, labels: [String], timeCreated: Date, srcURL: String, platform: String, location: CodableLocation, address: USAddress) {
        self.id = id
        self.name = name
        self.labels = labels
        self.timeCreated = timeCreated
        self.srcURL = srcURL
        self.platform = platform
        self.location = location
        self.address = address
    }
}

extension Restaurant {
    struct Migration: AsyncMigration {
        var name: String { "CreateRestaurant" }

        func prepare(on database: Database) async throws {
            try await database.schema("restaurant")
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
            try await database.schema("restaurant").delete()
        }
    }
}

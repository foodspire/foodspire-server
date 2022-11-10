import Fluent
import Vapor


final class Delivery: FoodChoice, ThirdPartyContent, MerchantContent {
    static let schema = "delivery"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
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
    
    @Field(key: "phone")
    var phone: String
    
    init() {}
    
    init(id: UUID? = nil, userID: UUID, name: String, labels: [String], timeCreated: Date, srcURL: String, platform: String, location: CodableLocation, address: USAddress, phone: String) {
        self.id = id
        self.$user.id = userID
        self.name = name
        self.labels = labels
        self.timeCreated = timeCreated
        self.srcURL = srcURL
        self.platform = platform
        self.location = location
        self.address = address
        self.phone = phone
    }
}

extension Delivery {
    struct Migration: AsyncMigration {
        var name: String { "CreateDelivery" }

        func prepare(on database: Database) async throws {
            try await database.schema("delivery")
                .id()
                .field("user_id", .uuid, .required, .references("users", "id"))
                .field("name", .string, .required)
                .field("labels", .array(of: .string), .required)
                .field("timeCreated", .datetime, .required)
                .field("srcURL", .string, .required)
                .field("platform", .string, .required)
                .field("location", .dictionary, .required)
                .field("address", .dictionary, .required)
                .field("phone", .string, .required)
                .unique(on: "srcURL")
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("delivery").delete()
        }
    }
}

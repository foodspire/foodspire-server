import Fluent
import Vapor

struct USAddress: Content {
//    @ID(key: .id)
//    var id: UUID?

//    @Field(key: "address1")
    let address1: String

//    @Field(key: "address2")
    let address2: String

//    @Field(key: "zipcode")
    let zipcode: Int
    
//    @Field(key: "city")
    let city: String
    
//    @Field(key: "state")
    let state: String

    init(address1: String, address2: String, zipcode: Int, city: String, state: String) {
        self.address1 = address1
        self.address2 = address2
        self.zipcode = zipcode
        self.city = city
        self.state = state
    }
}

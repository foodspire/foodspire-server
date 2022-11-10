import Fluent
import Vapor

struct USAddress: Content {
    let address1: String

    let address2: String?

    let zipcode: String
    
    let city: String
    
    let state: String

    init(address1: String, address2: String, zipcode: String, city: String, state: String) {
        self.address1 = address1
        self.address2 = address2
        self.zipcode = zipcode
        self.city = city
        self.state = state
    }
}

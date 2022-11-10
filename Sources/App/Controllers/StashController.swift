import Fluent
import Vapor

struct StashController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let cntlr = routes.grouped("stash")
            .grouped(UserToken.authenticator())
            .grouped(User.guardMiddleware())
        cntlr.get(use: get)
//        cntlr.put(use: put)
        cntlr.post("fromURL", use: fromURL)
    }
    
    func get(req: Request) async throws -> String {
        return "hello"
    }
    
//    func put(req: Request) async throws -> Response {
//        let foodChoiceInfo = try req.content.decode(FromAddressDTO.self)
//        var foodChoice: (any FoodChoice)?
//    }
    
    func fromURL(req: Request) async throws -> Response {
        let urlStr = try req.content.decode(FromURLDTO.self).url
        let url = URL(string: urlStr)!
        var foodChoice: (any FoodChoice)?
        if url.host!.contains("yelp.com") {
            foodChoice = try await createYelpFoodChoice(yelpBusinessID: url.lastPathComponent, req: req)
        } else if url.host!.contains("google.com") {
            foodChoice = try await createGoogleFoodChoice(url: url, client: req.client)
        }
        
        return try await encodeRequest(foodChoice: foodChoice, req: req)
    }
}

extension StashController {
    struct FromURLDTO: Content {
        var url: String
    }
    
    struct MatchAddressDTO: Content {
        var name: String
//        var labels: [String]
        var address: USAddress
    }
}

extension StashController {
    private func encodeRequest(foodChoice: (any FoodChoice)?, req: Request) async throws -> Response {
        switch foodChoice {
        case let foodChoice as Restaurant:
            try await foodChoice.save(on: req.db)
            return try await ModelDTO(from: foodChoice).encodeResponse(for: req)
        case let foodChoice as Delivery:
            try await foodChoice.save(on: req.db)
            return try await ModelDTO(from: foodChoice).encodeResponse(for: req)
        default:
            return Response(status: .badRequest)
        }
    }
}


extension StashController {
    private func createYelpFoodChoice(yelpBusinessID id: String, req: Request) async throws -> Restaurant {
        let YELP_API_ENDPOINT = Environment.get("YELP_API_ENDPOINT")!
        let YELP_API_KEY = Environment.get("YELP_API_KEY")!
        let response = try await req.client.get("\(YELP_API_ENDPOINT)/\(id)", headers: HTTPHeaders(dictionaryLiteral: ("Authorization", "Bearer \(YELP_API_KEY)")))
        let user = try req.auth.require(User.self)
        let businessDetail = try JSONSerialization.jsonObject(with: response.body!) as! [String: Any]
        var restaurant = parseYelpBusinessDetail(businessDetail)
        restaurant.$user.id = user.id!
        return restaurant
    }
    
    private func parseYelpBusinessDetail(_ businessDetail: [String: Any]) -> Restaurant {
        let locationDict = businessDetail["coordinates"] as! [String: Double]
        let addressDict = businessDetail["location"] as! [String: Any]
        return Restaurant(
            name: businessDetail["name"] as! String,
            labels: (businessDetail["categories"] as! [[String: String]]).map { $0["title"]! },
            timeCreated: Date.now,
            srcURL: businessDetail["url"] as! String,
            platform: "Yelp",
            location: CodableLocation(latitude: locationDict["latitude"]!, longitude: locationDict["longitude"]!, altitude: 0),
            address: USAddress(address1: addressDict["address1"] as! String, address2: addressDict["address2"] as! String, zipcode: addressDict["zip_code"] as! String, city: addressDict["city"] as! String, state: addressDict["state"] as! String),
            phone: businessDetail["phone"] as! String)
    }
}

extension StashController {
    private func createGoogleFoodChoice(url: URL, client: Client) async throws -> Restaurant {
        // TODO: support Google Maps URLs
        return Restaurant()
    }
}

struct CodableLocation: Codable {
    let latitude: Float
    let longitude: Float
    let altitude: Float
    init(latitude: Float, longitude: Float, altitude: Float) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
}

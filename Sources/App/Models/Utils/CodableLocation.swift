struct CodableLocation: Codable {
    let latitude: Double
    let longitude: Double
    let altitude: Double
    init(latitude: Double, longitude: Double, altitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
}

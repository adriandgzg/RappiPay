import Foundation
import ObjectMapper

struct Dates : Mappable {
	var maximum : String?
	var minimum : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		maximum <- map["maximum"]
		minimum <- map["minimum"]
	}

}

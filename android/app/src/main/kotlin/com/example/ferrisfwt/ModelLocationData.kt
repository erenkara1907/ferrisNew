package com.example.ferrisfwt

data class ModelLocationData(
    val latitude: Double,
    val longitude: Double,
    val altitude: Double,
    val speed: Double,
    val bearing: Double,
    val accuracy: Double,
    val timeAtMillis: Long,
    val isAddToPathNodes: Boolean
) {
    companion object fun fromMap(map: Map<String, Any?>): ModelLocationData {
        return ModelLocationData(
            map["latitude"] as Double,
            map["longitude"] as Double,
            map["altitude"] as Double,
            map["speed"] as Double,
            map["bearing"] as Double,
            map["accuracy"] as Double,
            map["timeAtMillis"] as Long,
            map["isAddToPathNodes"] as Boolean
        )
    }

    fun toMap(): Map<String, Any> {
        return hashMapOf(
            Pair("latitude", latitude),
            Pair("longitude", longitude),
            Pair("altitude", altitude),
            Pair("speed", speed),
            Pair("bearing", bearing),
            Pair("accuracy", accuracy),
            Pair("timeAtMillis", timeAtMillis),
            Pair("isAddToPathNodes", isAddToPathNodes)
        )
    }
}

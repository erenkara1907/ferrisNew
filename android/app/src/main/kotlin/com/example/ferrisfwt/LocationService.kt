package com.example.ferrisfwt

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Color
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Binder
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationCompat.PRIORITY_MIN
import io.flutter.plugin.common.EventChannel
import okhttp3.Call
import okhttp3.Callback
import okhttp3.MediaType
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.Response
import org.json.JSONObject
import java.io.IOException
import java.lang.Exception


class LocationService : Service(), EventChannel.StreamHandler {
    private var binder: LocationServiceBinder? = null

    override fun onBind(p0: Intent?): IBinder = binder!!

    // manage location tracking and listen by these variables
    private var mLocationManager: LocationManager? = null
    private var locationListener: LocationListener? = null

    var isTracking: Boolean = false
    var lastSpeed: Double = 0.0
    val pathNodes: MutableList<ModelLocationData> = mutableListOf()

    /**
     * assign this object in onListen function in StreamHandler. Service streams location data to
     * dart side by this object.
     */
    var events: EventChannel.EventSink? = null

    var tokenUpdateEvent: EventChannel.EventSink? = null

    private var notificationSmallIcon: Int = android.R.drawable.sym_def_app_icon
    private var notificationLargeIcon: Bitmap? = null

    companion object {
        private const val TAG = "LocationService"
        const val CHANNEL_ID = "notificationChannelID"
        const val CHANNEL_NAME = "notificationChannelName"
        private const val LOCATION_INTERVAL: Long = 5000 // in millisecond
        private const val LOCATION_DISTANCE: Float = 0f
        private const val NOTIFICATION_ID = 101
        private const val URL_LOCATION_POST = "https://test.fwtsolutions.co.uk/api/v1/job-tracking-cordinates"

        var token: String? = null
        var newToken: String? = null
        var jobId: Int? = null
    }

    override fun toString(): String {
        return "isRunning: $isTracking | lastSpeed: $lastSpeed | pathNodes: $pathNodes"
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        tokenUpdateEvent = events
    }

    override fun onCancel(arguments: Any?) {
        tokenUpdateEvent = null
    }

    inner class LocationServiceBinder : Binder() {
        val service: LocationService
            get() = this@LocationService
    }

    override fun onCreate() {
        Log.i(TAG, "onCreate: called")
        super.onCreate()
        binder = LocationServiceBinder()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.i(TAG, "onStartCommand: called")
        super.onStartCommand(intent, flags, startId)
        startForeground()
        startLocationTracking()
        return START_STICKY
    }

    override fun onDestroy() {
        Log.i(TAG, "onDestroy: called")
        super.onDestroy()
    }

    fun stopService() {
        Log.i(TAG, "stopService: called")
        pathNodes.clear()
        pauseTracking()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        }
        if (notificationManager != null) {
            notificationManager!!.cancel(NOTIFICATION_ID)
        } else {
            Log.e(TAG, "stopService: notificationManager was null when stopService called")
        }
        initializeLocationManager()
        mLocationManager!!.removeUpdates(locationListener!!)
        locationListener = null
        stopSelf()
    }

    fun startTracking() {
        Log.i(TAG, "startTracking: called")
        isTracking = true

        if (locationListener == null) {
            startLocationTracking()
        }

    }

    fun pauseTracking() {
        if (locationListener == null) {
            Log.i(TAG, "pauseService: location listener is null")
            if (isTracking) {
                Log.e(TAG, "pauseService: isRunning is true when location listener is null")
            }
        }
        isTracking = false
    }

    fun clearPathNodes() {
        pathNodes.clear()
    }

    /**
     * Starts to listen location changes. This function assigns locationListener variable.
     */
    private fun startLocationTracking() {
        locationListener = object : LocationListener {
            override fun onLocationChanged(location: Location) {
                Log.i(TAG, "onLocationChanged: $location")
                Log.i(TAG, "onLocationChanged: isTracking: $isTracking")

                // create location data by location
                val isAddToPathNodes =
                    ((location.speed != 0.0f || lastSpeed != 0.0) || pathNodes.size == 0) && isTracking
                val locationData = ModelLocationData(
                    location.latitude,
                    location.longitude,
                    location.altitude,
                    location.speed.toDouble(),
                    location.bearing.toDouble(),
                    location.accuracy.toDouble(),
                    location.time,
                    isAddToPathNodes
                )

                // add location data to pathNodes
                if (isTracking && isAddToPathNodes) {
                    pathNodes.add(locationData)
                    postLocation(
                        jobId,
                        locationData.timeAtMillis / 1000,
                        locationData.latitude,
                        locationData.longitude
                    )
                }

                // send location data to dart side
                val locationDataMap = locationData.toMap()
                events?.success(locationDataMap)
                Log.i(
                    TAG,
                    "onLocationChanged: flutter side event object: ${if (events == null) "Null" else "Exists"}"
                )

                // update lastSpeed
                lastSpeed = location.speed.toDouble()

                // refresh notification
                updateNotification(location)
            }

            override fun onProviderEnabled(provider: String) {
                //events?.success(true)
            }

            override fun onProviderDisabled(provider: String) {
                //events?.success(false)
            }
        }

        initializeLocationManager()

        try {
            if (ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.ACCESS_FINE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.ACCESS_COARSE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                Log.i(TAG, "startLocationTracking: permission denied")
                return
            }
            Log.i(TAG, "startLocationTracking: permission granted")
            mLocationManager!!.requestLocationUpdates(
                LocationManager.GPS_PROVIDER, LOCATION_INTERVAL, LOCATION_DISTANCE,
                locationListener!!
            )
        } catch (ex: IllegalArgumentException) {
            Log.e(TAG, "startLocationTracking: location cannot listen")
            throw ex
        }
    }

    /**
     * Posts location data to server
     */
    private fun postLocation(jobId: Int?, addedTime: Long, latitude: Double, longitude: Double) {
        val json = """
            {
                "jobId": $jobId,
                "addedTime": $addedTime,
                "latitude": "$latitude",
                "longitude": "$longitude"
            }
        """.trimIndent()
        val response = post(URL_LOCATION_POST, json)
        Log.i(TAG, "postLocation: response: $response")
    }

    private val json: MediaType = "application/json; charset=utf-8".toMediaType()
    private var client = OkHttpClient()

    @Throws(IOException::class)
    fun post(url: String, json: String): String {
        val body: RequestBody = json.toRequestBody(this.json)
        val request: Request = Request.Builder()
            .url(url)
            .post(body)
            .header("Authorization", "Bearer $token")
            .header("Content-Type", "application/json")
            .build()
        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {}

            override fun onResponse(call: Call, response: Response) {
                response.use {
                    for ((name, value) in response.headers) {
                        println("$name: $value")
                        Log.i(TAG, "onResponse: header: $name: $value")
                    }
                    Log.i(TAG, "onResponse: body: ${response.body?.string()}")

                    val newAccessToken = try {
                        JSONObject(response.body?.string() ?: "{}").getString("newAccessToken")
                    } catch (e: Exception) {
                        null
                    }
                    if (newAccessToken != null) {
                        token = newAccessToken
                        newToken = newAccessToken
                        tokenUpdateEvent?.success(newToken)
                    }
                }
            }
        })
        return ""
    }

    /**
     * Initializes the LocationManager.
     * Call for being sure that the LocationManager is initialized
     */
    private fun initializeLocationManager() {
        if (mLocationManager == null) {
            mLocationManager =
                applicationContext.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        }
    }

    /**
     * Updates the notification text
     * @param location the current location
     */
    fun updateNotification(location: Location) {
        if (notificationBuilder != null && notificationManager != null) {
            notificationBuilder!!.setContentText(location.latitude.toString() + ", " + location.longitude.toString())
            notificationManager!!.notify(101, notificationBuilder!!.build())
        }
    }

    private var notification: Notification? = null
    private var notificationBuilder: NotificationCompat.Builder? = null
    private var notificationManager: NotificationManager? = null

    /**
     * Starts to show the notification related to the service
     */
    private fun startForeground() {
        val channelId =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                createNotificationChannel()
            } else {
                // If earlier version channel ID is not used
                // https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Builder.html#NotificationCompat.Builder(android.content.Context)
                ""
            }

        notificationBuilder = NotificationCompat.Builder(this, channelId)
        notification = notificationBuilder!!.setOngoing(true)
            .setContentTitle("service notification")
            .setContentText("service started")
            .setSmallIcon(notificationSmallIcon)
            .setLargeIcon(notificationLargeIcon)
            .setPriority(PRIORITY_MIN)
            .setCategory(Notification.CATEGORY_SERVICE)
            .build()
        startForeground(NOTIFICATION_ID, notification)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun createNotificationChannel(): String {
        val chan = NotificationChannel(
            CHANNEL_ID,
            CHANNEL_NAME, NotificationManager.IMPORTANCE_NONE
        )
        chan.lightColor = Color.BLUE
        chan.lockscreenVisibility = Notification.VISIBILITY_PRIVATE
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager!!.createNotificationChannel(chan)
        return CHANNEL_ID
    }
}
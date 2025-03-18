package com.example.ferrisfwt

import android.content.ComponentName
import android.content.Intent
import android.content.ServiceConnection
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    companion object {
        const val TAG = "MainActivity"
        const val METHOD = "com.ferris.method_channel"
        const val STREAM = "com.ferris.event_channel"
        const val STREAM_NEW_TOKEN = "com.ferris.token_event_channel"
        const val funcStartService = "start_location_service"
        const val funcResumeService = "resume_location_service"
        const val funcPauseService = "pause_location_service"
        const val funcStopService = "stop_location_service"
        const val funcIsServiceStarted = "is_location_service_started"
        const val funcIsServiceRunning = "is_location_service_running"
        const val funcGetPathNodes = "get_path_nodes"
        const val funcClearPathNodes = "clear_path_nodes"
        const val funcSetToken = "set_token"
        const val funcSetJobId = "set_job_id"
        const val funcGetNewAccessToken = "get_new_access_token"
        const val funcDeleteNewAccessToken = "delete_new_access_token"
    }

    private var tokenEventChannel: EventChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize permission utils channel
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, METHOD).setMethodCallHandler(this)
    }

    override fun onDestroy() {
        Log.i(TAG, "onDestroy: called")
        if (isServiceStarted() && !isTracking()) {
            Log.i(TAG, "onDestroy: service is started but location is not tracking, stop service")
            stopService()
        }
        doUnbindService()
        super.onDestroy()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize main method channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD).setMethodCallHandler(this)

        // Initialize event channels
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, STREAM).setStreamHandler(this)
        tokenEventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, STREAM_NEW_TOKEN)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.i(TAG, "onMethodCall: ${call.method}")
        when (call.method) {
            funcStartService -> {
                Log.i(TAG, "onMethodCall: funcStartService called")
                val error = startService()
                result.success(error)
                if (error != null) Log.e(TAG, "onMethodCall: error: $error")
            }
            funcStopService -> {
                Log.i(TAG, "onMethodCall: funcStopService called")
                val error = stopService()
                result.success(error)
                if (error != null) Log.e(TAG, "onMethodCall: error: $error")
            }
            funcResumeService -> {
                Log.i(TAG, "onMethodCall: funcResumeService called")
                val error = startTracking()
                result.success(error)
                if (error != null) Log.e(TAG, "onMethodCall: error: $error")
            }
            funcPauseService -> {
                Log.i(TAG, "onMethodCall: funcPauseService called")
                val error = pauseTracking()
                result.success(error)
                if (error != null) Log.e(TAG, "onMethodCall: error: $error")
            }
            funcIsServiceStarted -> {
                Log.i(TAG, "onMethodCall: funcIsServiceStarted called")
                result.success(isServiceStarted())
            }
            funcIsServiceRunning -> {
                Log.i(TAG, "onMethodCall: funcIsServiceRunning called")
                result.success(isTracking())
            }
            funcGetPathNodes -> {
                Log.i(TAG, "onMethodCall: funcGetPathNodes called")
                result.success(getPathNodes())
            }
            funcClearPathNodes -> {
                Log.i(TAG, "onMethodCall: funcClearPathNodes called")
                result.success(clearPathNodes())
            }
            funcSetToken -> {
                val token = (call.arguments as? Map<*, *>)?.get("token") as? String
                if (token == null) {
                    result.error("INVALID_ARGUMENT", "Token cannot be null", null)
                    return
                }
                val error = setToken(token)
                result.success(error)
                if (error != null) Log.e(TAG, "onMethodCall: error: $error")
            }
            funcSetJobId -> {
                val jobId = (call.arguments as? Map<*, *>)?.get("jobId") as? Int
                if (jobId == null) {
                    result.error("INVALID_ARGUMENT", "Job ID cannot be null", null)
                    return
                }
                val error = setJobId(jobId)
                result.success(error)
                if (error != null) Log.e(TAG, "onMethodCall: error: $error")
            }
            funcGetNewAccessToken -> {
                result.success(LocationService.newToken)
            }
            funcDeleteNewAccessToken -> {
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (mBoundService == null) throw Exception("LocationService has not been started")
        mBoundService?.events = events
    }

    override fun onCancel(arguments: Any?) {
        mBoundService?.events = null
    }

    private var mShouldUnbind = false
    private var mBoundService: LocationService? = null

    private val mConnection: ServiceConnection = object : ServiceConnection {
        override fun onServiceConnected(className: ComponentName, service: IBinder) {
            mBoundService = (service as LocationService.LocationServiceBinder).service
            Log.i(TAG, "onServiceConnected: Service connected")
        }

        override fun onServiceDisconnected(className: ComponentName) {
            mBoundService = null
            Log.e(TAG, "onServiceDisconnected: Service has unexpectedly disconnected")
        }
    }

    private fun doBindService(intent: Intent): Boolean {
        if (mShouldUnbind) {
            Log.i(TAG, "doBindService: service already bound")
            return true
        }
        if (bindService(intent, mConnection, BIND_AUTO_CREATE)) {
            mShouldUnbind = true
        }
        Log.i(TAG, "doBindService: service was not bound")
        return false
    }

    private fun doUnbindService() {
        if (mShouldUnbind) {
            unbindService(mConnection)
            mShouldUnbind = false
            mBoundService = null
            Log.i(TAG, "doUnbindService: service unbound")
        } else {
            Log.i(TAG, "doUnbindService: service should not unbound")
        }
    }

    private fun startService(): String? {
        val intent = Intent(this, LocationService::class.java)
        if (mBoundService != null) {
            doBindService(intent)
            return "service already started"
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
        doBindService(intent)
        return null
    }

    private fun stopService(): String? {
        if (mBoundService == null) return "mBoundService not found"
        mBoundService!!.stopService()
        doUnbindService()
        return null
    }

    private fun startTracking(): String? {
        if (mBoundService == null) return "mBoundService not found"
        else if (mBoundService!!.isTracking) return "mBoundService already resumed"
        mBoundService!!.startTracking()
        tokenEventChannel?.setStreamHandler(mBoundService!!)
        return null
    }

    private fun pauseTracking(): String? {
        if (mBoundService == null) return "mBoundService not found"
        else if (!mBoundService!!.isTracking) return "mBoundService already paused"
        mBoundService!!.pauseTracking()
        tokenEventChannel?.setStreamHandler(null)
        return null
    }

    private fun isServiceStarted(): Boolean {
        return mBoundService != null
    }

    private fun isTracking(): Boolean {
        return mBoundService?.isTracking ?: false
    }

    private fun getPathNodes(): List<Map<String, Any?>> {
        return mBoundService?.pathNodes?.map { it.toMap() } ?: emptyList()
    }

    private fun clearPathNodes(): String? {
        if (mBoundService == null) return "mBoundService not found"
        mBoundService!!.clearPathNodes()
        return null
    }

    private fun setToken(token: String): String? {
        LocationService.token = token
        return null
    }

    private fun setJobId(jobId: Int): String? {
        LocationService.jobId = jobId
        return null
    }
}
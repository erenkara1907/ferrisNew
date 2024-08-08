package com.example.ferrisfwt

import android.content.ComponentName
import android.content.Intent
import android.content.ServiceConnection
import android.os.Build
import android.os.IBinder
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler {

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
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD).setMethodCallHandler(this)
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
                val token = (call.arguments as HashMap<*, *>)["token"] as String
                val error = setToken(token)
                result.success(error)
                if (error != null) Log.e(TAG, "onMethodCall: error: $error")
            }
            funcSetJobId -> {
               val jobId = (call.arguments as HashMap<*, *>)["jobId"] as Int
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
        Log.i(TAG, "onMethodCall end: ${call.method} | result: $result")
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (mBoundService == null) throw Exception("LocationService has not been started")
        mBoundService?.events = events
    }

    override fun onCancel(arguments: Any?) {
        mBoundService?.events = null
    }

    // Don't attempt to unbind from the service unless the client has received some
    // information about the service's state.
    private var mShouldUnbind = false

    // To invoke the bound service, first make sure that this value
    // is not null.
    private var mBoundService: LocationService? = null

    private val mConnection: ServiceConnection = object : ServiceConnection {
        override fun onServiceConnected(className: ComponentName, service: IBinder) {
            // This is called when the connection with the service has been
            // established, giving us the service object we can use to
            // interact with the service.  Because we have bound to a explicit
            // service that we know is running in our own process, we can
            // cast its IBinder to a concrete class and directly access it.
            mBoundService = (service as LocationService.LocationServiceBinder).service
            Log.i(TAG, "onServiceConnected: Service connected")
        }

        override fun onServiceDisconnected(className: ComponentName) {
            // This is called when the connection with the service has been
            // unexpectedly disconnected -- that is, its process crashed.
            // Because it is running in our same process, we should never
            // see this happen.
            mBoundService = null
            Log.e(TAG, "onServiceDisconnected: Service has unexpectedly disconnected")
        }
    }

    /**
     * Bind to the service. call this function after service is started. Also can be callable on
     * on create function when service is already running. If returns false, it means service has
     * to be started, then doBindService function should be called again.
     * @return true if service and bound successfully.
     * @return false if service and service should be started before binding.
     * @param intent intent to bind service
     */
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

    /**
     * Unbind from the service. call this function when service is stopped or activity is destroyed.
     * This function checks if the service is bound or not. If the service is bound, it unbinds the
     * service. Otherwise, it does nothing.
     */
    private fun doUnbindService() {
        if (mShouldUnbind) {
            // Release information about the service's state.
            unbindService(mConnection)
            mShouldUnbind = false
            mBoundService = null
            Log.i(TAG, "doUnbindService: service unbound")
        } else {
            Log.i(TAG, "doUnbindService: service should not unbound")
            if (mBoundService != null) {
                Log.e(TAG, "doUnbindService: service was bounded when mShouldUnbind is false")
            }
        }
    }

    /**
     * Start the service
     * return null if success
     * return error message if failed
     */
    private fun startService(): String? {
        val intent = Intent(context, LocationService::class.java)

        // if service is already started, try to bind and return error message.
        if (mBoundService != null) {
            doBindService(intent)
            return "service already started"
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            context.startForegroundService(intent)
        else context.startService(intent)

        // bind the service
        doBindService(intent)

        return null
    }

    /**
     * Stop the service
     * return null if success
     * return error message if failed
     */
    private fun stopService(): String? {
        if (mBoundService == null) return "mBoundService not found"
        mBoundService!!.stopService()
        doUnbindService()
        return null
    }

    /**
     * Resume the service
     * return null if success
     * return error message if failed
     */
    private fun startTracking(): String? {
        if (mBoundService == null) return "mBoundService not found"
        else if (mBoundService!!.isTracking) return "mBoundService already resumed"
        mBoundService!!.startTracking()
        tokenEventChannel?.setStreamHandler(mBoundService!!)
        return null
    }

    /**
     * Pause the service
     * return null if success
     * return error message if failed
     */
    private fun pauseTracking(): String? {
        if (mBoundService == null) return "mBoundService not found"
        else if (!mBoundService!!.isTracking) return "mBoundService already paused"
        mBoundService!!.pauseTracking()
        tokenEventChannel?.setStreamHandler(null)
        return null
    }

    /**
     * Check if the service is started
     * return true if started
     * return false if not started
     */
    private fun isServiceStarted(): Boolean {
        if (mBoundService != null) return true
        return false
    }

    /**
     * Check if the service is running (not paused)
     * return true if running
     * return false if not running
     */
    private fun isTracking(): Boolean {
        return mBoundService?.isTracking ?: false
    }

    /**
     * Get path nodes
     * return list of path nodes
     */
    private fun getPathNodes(): List<Map<String, Any?>> {
        return mBoundService?.pathNodes?.map { it.toMap() } ?: emptyList()
    }

    private fun clearPathNodes(): String? {
        if (mBoundService == null) return "mBoundService not found"
        mBoundService!!.clearPathNodes()
        return null
    }

    /**
     * Set token
     * return null if success
     * return error message if failed
     */
    private fun setToken(token: String): String? {
        LocationService.token = token
        return null
    }

    /**
     * Set jobId
     * return null if success
     * return error message if failed
     */
    private fun setJobId(jobId: Int): String? {
        LocationService.jobId = jobId
        return null
    }
}

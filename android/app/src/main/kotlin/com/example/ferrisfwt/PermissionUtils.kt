package com.example.ferrisfwt

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat

object PermissionUtils {
    fun isForegroundServiceLocationPermissionGranted(context: Context): Boolean {
        return ActivityCompat.checkSelfPermission(
            context,
            Manifest.permission.FOREGROUND_SERVICE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED
    }
}
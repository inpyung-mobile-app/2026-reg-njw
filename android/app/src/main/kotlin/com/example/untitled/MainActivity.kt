package com.example.untitled

import android.os.Bundle
import android.os.PersistableBundle
import android.provider.MediaStore
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "toast").setMethodCallHandler { call, result ->
            if (call.method == "message") {
                val text = call.argument<String>("text")

                Toast.makeText(this, text, Toast.LENGTH_SHORT).show()
                result.success(null)
            }
        }
    }
}

package sk.virtualvoid.nyxdroid.v2

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.OpenableColumns
import android.webkit.MimeTypeMap
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private var channel: MethodChannel? = null
    private var initialShare: Map<String, String?>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        initialShare = extractShare(intent)
        val shareChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        shareChannel.setMethodCallHandler { call, result ->
            if (call.method == "getInitialShare") {
                result.success(initialShare)
                initialShare = null
            } else {
                result.notImplemented()
            }
        }
        channel = shareChannel
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        extractShare(intent)?.let { channel?.invokeMethod("onShare", it) }
    }

    private fun extractShare(intent: Intent?): Map<String, String?>? {
        if (intent == null || intent.action != Intent.ACTION_SEND) return null
        val type = intent.type ?: return null
        intent.action = Intent.ACTION_MAIN

        if (type.startsWith("image/")) {
            val uri = streamUri(intent) ?: return mapOf("type" to "image", "path" to null, "name" to null)
            val file = copyToCache(uri, type)
            return mapOf("type" to "image", "path" to file?.absolutePath, "name" to file?.name)
        }
        if (type.startsWith("text/")) {
            val text = intent.getStringExtra(Intent.EXTRA_TEXT) ?: return null
            return mapOf("type" to "text", "text" to text)
        }
        return null
    }

    @Suppress("DEPRECATION")
    private fun streamUri(intent: Intent): Uri? =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
        } else {
            intent.getParcelableExtra(Intent.EXTRA_STREAM)
        }

    private fun copyToCache(uri: Uri, type: String): File? {
        return try {
            var name: String? = null
            contentResolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)?.use {
                if (it.moveToFirst()) name = it.getString(0)
            }
            val extension = MimeTypeMap.getSingleton().getExtensionFromMimeType(type) ?: "jpg"
            val safeName = (name ?: "shared_${System.currentTimeMillis()}.$extension")
                .replace(Regex("[^A-Za-z0-9._-]"), "_")
            val dir = File(cacheDir, "shared").apply { mkdirs() }
            val target = File(dir, safeName)
            contentResolver.openInputStream(uri)?.use { input ->
                target.outputStream().use { input.copyTo(it) }
            } ?: return null
            target
        } catch (e: Exception) {
            null
        }
    }

    companion object {
        private const val CHANNEL = "sk.virtualvoid.nyxdroid/share"
    }
}

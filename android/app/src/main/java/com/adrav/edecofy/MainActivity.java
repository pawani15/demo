package com.adrav.edecofy;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.webkit.MimeTypeMap;
import android.widget.Toast;

import java.io.File;
import java.util.ArrayList;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import androidx.core.content.FileProvider;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.adrav.edecofy/filepicker";
    private static String fileType;
    private static MethodChannel.Result result;
    private static final String TAG = "FilePicker";
    private static boolean isMultipleSelection = false;
    private static final int REQUEST_CODE = (FilePickerPlugin.class.hashCode() + 43) & 0x0000ffff;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {

                        if (call.method.equalsIgnoreCase("ANY")) {
                            MainActivity.result = result;
                            fileType = resolveType(call.method);
                            isMultipleSelection = (boolean) call.arguments;

                            if (fileType == null) {
                                result.notImplemented();
                            } else if (fileType.equals("unsupported")) {
                                result.error(TAG, "Unsupported filter. Make sure that you are only using the extension without the dot, (ie., jpg instead of .jpg). This could also have happened because you are using an unsupported file extension.  If the problem persists, you may want to consider using FileType.ALL instead.", null);
                            } else {
                                Intent intent;
                                intent = new Intent(Intent.ACTION_GET_CONTENT);
                                Uri uri = Uri.parse(Environment.getExternalStorageDirectory().getPath() + File.separator);
                                intent.setDataAndType(uri, fileType);
                                intent.setType(fileType);
                                intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, isMultipleSelection);
                                intent.addCategory(Intent.CATEGORY_OPENABLE);

                                if (intent.resolveActivity(getPackageManager()) != null) {
                                    startActivityForResult(intent, REQUEST_CODE);
                                } else {
                                    Log.e(TAG, "Can't find a valid activity to handle the request. Make sure you've a file explorer installed.");
                                    result.error(TAG, "Can't handle the provided file type.", null);
                                }

                            }
                        }
                        else if(call.method.equalsIgnoreCase("openfile")){
                            String url = call.argument("url");
                            File file = new File(url);
                            openFile(MainActivity.this,file);
                        }
                        else if(call.method.equalsIgnoreCase("webview")){
                            String url = call.argument("url");
                            String endurl = call.argument("endurl");
                            startActivity(new Intent(MainActivity.this,Webview.class).putExtra("url",url).putExtra("endurl",endurl));
                        }
                    }
                });
    }

    private void openFile(Context context, File url) {
        try {

            //Uri uri = Uri.fromFile(url);
            Uri uri = FileProvider.getUriForFile(MainActivity.this,
                    BuildConfig.APPLICATION_ID + ".provider",
                    url);
            //Uri uri = Uri.parse(url.getPath());

            Intent intent = new Intent(Intent.ACTION_VIEW);
            Log.i("urii",""+uri);
            if (url.toString().contains(".doc") || url.toString().contains(".docx")) {
                // Word document
                intent.setDataAndType(uri, "application/msword");
            } else if (url.toString().contains(".pdf")) {
                // PDF file
                intent.setDataAndType(uri, "application/pdf");
            } else if (url.toString().contains(".ppt") || url.toString().contains(".pptx")) {
                // Powerpoint file
                intent.setDataAndType(uri, "application/vnd.ms-powerpoint");
            } else if (url.toString().contains(".xls") || url.toString().contains(".xlsx")) {
                // Excel file
                intent.setDataAndType(uri, "application/vnd.ms-excel");
            } else if (url.toString().contains(".zip") || url.toString().contains(".rar")) {
                // WAV audio file
                intent.setDataAndType(uri, "application/x-wav");
            } else if (url.toString().contains(".rtf")) {
                // RTF file
                intent.setDataAndType(uri, "application/rtf");
            } else if (url.toString().contains(".wav") || url.toString().contains(".mp3")) {
                // WAV audio file
                intent.setDataAndType(uri, "audio/x-wav");
            } else if (url.toString().contains(".gif")) {
                // GIF file
                intent.setDataAndType(uri, "image/gif");
            } else if (url.toString().contains(".jpg") || url.toString().contains(".jpeg") || url.toString().contains(".png")) {
                // JPG file
                intent.setDataAndType(uri, "image/jpeg");
            } else if (url.toString().contains(".txt")) {
                // Text file
                intent.setDataAndType(uri, "text/plain");
            } else if (url.toString().contains(".3gp") || url.toString().contains(".mpg") ||
                    url.toString().contains(".mpeg") || url.toString().contains(".mpe") || url.toString().contains(".mp4") || url.toString().contains(".avi")) {
                // Video files
                intent.setDataAndType(uri, "video/*");
            } else {
                intent.setDataAndType(uri, "*/*");
            }

            intent.setFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            startActivity(intent);
        } catch (ActivityNotFoundException e) {
            Toast.makeText(context, "No application found which can open the file", Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, final Intent data) {

        if (requestCode == REQUEST_CODE && resultCode == Activity.RESULT_OK) {

            new Thread(new Runnable() {
                @Override
                public void run() {
                    if (data != null) {
                        if(data.getClipData() != null) {
                            int count = data.getClipData().getItemCount();
                            int currentItem = 0;
                            ArrayList<String> paths = new ArrayList<>();
                            while(currentItem < count) {
                                final Uri currentUri = data.getClipData().getItemAt(currentItem).getUri();
                                String path = FileUtils.getPath(currentUri, MainActivity.this);
                                if(path == null) {
                                    path =  FileUtils.getUriFromRemote(MainActivity.this, currentUri, result);
                                }
                                paths.add(path);
                                Log.i(TAG, "[MultiFilePick] File #" + currentItem + " - URI: " +currentUri.getPath());
                                currentItem++;
                            }
                            if(paths.size() > 1){
                                runOnUiThread(result, paths, true);
                            } else {
                                runOnUiThread(result, paths.get(0), true);
                            }
                        } else if (data.getData() != null) {
                            Uri uri = data.getData();
                            Log.i(TAG, "[SingleFilePick] File URI:" + uri.toString());
                            String fullPath = FileUtils.getPath(uri, MainActivity.this);

                            if(fullPath == null) {
                                fullPath =  FileUtils.getUriFromRemote(MainActivity.this, uri, result);
                            }

                            if(fullPath != null) {
                                Log.i(TAG, "Absolute file path:" + fullPath);
                                runOnUiThread(result, fullPath, true);
                            } else {
                                runOnUiThread(result, "Failed to retrieve path.", false);
                            }
                        } else {
                            runOnUiThread(result, "Unknown activity error, please fill an issue.", false);
                        }
                    } else {
                        runOnUiThread(result, "Unknown activity error, please fill an issue.", false);
                    }
                }
            }).start();

        } else if(requestCode == REQUEST_CODE && resultCode == Activity.RESULT_CANCELED) {
            result.success(null);
        } else if (requestCode == REQUEST_CODE) {
            result.error(TAG, "Unknown activity error, please fill an issue." ,null);
        }
    }

    private void runOnUiThread(final MethodChannel.Result result, final Object o, final boolean success) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if(success) {
                    result.success(o);
                } else if(o != null) {
                    result.error(TAG,(String)o, null);
                } else {
                    result.notImplemented();
                }
            }
        });
    }

    private String resolveType(String type) {

        final boolean isCustom = type.contains("__CUSTOM_");

        if(isCustom) {
            final String extension = type.split("__CUSTOM_")[1].toLowerCase();
            String mime = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
            mime = mime == null ? "unsupported" : mime;
            Log.i("file", "Custom file type: " + mime);
            return mime;
        }

        switch (type) {
            case "AUDIO":
                return "audio/*";
            case "IMAGE":
                return "image/*";
            case "VIDEO":
                return "video/*";
            case "ANY":
                return "*/*";
            default:
                return null;
        }
    }

}

import android.content.Intent;
import android.net.Uri;
import android.widget.ImageView;
import android.database.Cursor;
import android.provider.MediaStore;
import android.content.CursorLoader;


class FileChooser {

  private final int FILE_SELECT_CODE = 0; 

  void show() { 
    Intent intent = new Intent(Intent.ACTION_GET_CONTENT); 
    intent.setType("image/*"); 
    intent.addCategory(Intent.CATEGORY_OPENABLE); 
    try { 
      startActivityForResult( Intent.createChooser(intent, "Select a File to Upload"), FILE_SELECT_CODE);
    } 
    catch (android.content.ActivityNotFoundException ex) { // Potentially direct the user to the Market with a Dialog Toast.
      Toast.makeText(context, "Please install a File Manager.", Toast.LENGTH_SHORT).show();
    }
  }
}

@Override
  public void onActivityResult(int requestCode, int resultCode, Intent data) {
  println("Chose file!");
  if (resultCode == this.getActivity().RESULT_OK) {
    println("Result ok!");
     if (requestCode == 0) {
        Uri selectedImage = data.getData();
              String[] filePathColumn = { MediaStore.Images.Media.DATA};
              // Get the cursor
                Cursor cursor = context.getContentResolver().query(selectedImage, 
                  filePathColumn, null, null, null);
              // Move to first row
                cursor.moveToFirst();
              int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
              String img = cursor.getString(columnIndex);
              cursor.close();   
      println(img);
      println(selectedImage.getPath());
      if (img == null){
        img = getRealPath(context, selectedImage.getPath());
        println("failed - new path: " + img);
      }
        load(img); 
    }
     
  }
}

/*

public static String getRealPath(Context context, Uri contentUri) { 
  String[] proj = { MediaStore.Images.Media.DATA }; 
  String result = null; 
  CursorLoader cursorLoader = new CursorLoader( context, contentUri, proj, null, null, null); 
  Cursor cursor = cursorLoader.loadInBackground(); 
  if (cursor != null) { 
    int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA); 
    cursor.moveToFirst(); 
    result = cursor.getString(column_index);
  } 
  return result;
}

*/
public static String getRealPath(Context context, String wholeID) { 
 String filePath = ""; 
 //String wholeID = DocumentsContract.getDocumentId(uri); // Split at colon, use second item in the array 
 String id = wholeID.split(":")[1]; 
 String[] column = { MediaStore.Images.Media.DATA }; // where id is equal to 
 String sel = MediaStore.Images.Media._ID + "=?"; 
 Cursor cursor = context.getContentResolver().query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, column, sel, new String[]{ id }, null); 
 int columnIndex = cursor.getColumnIndex(column[0]); 
 if (cursor.moveToFirst()) { 
 filePath = cursor.getString(columnIndex);
 } 
 cursor.close(); 
 return filePath;
 }


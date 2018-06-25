class textField{
  
  
public void onSfart() {
  //show or hide the keyboard at start

  activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
  edit = new EditText(context);
  edit.setLayoutParams(new RelativeLayout.LayoutParams( RelativeLayout.LayoutParams.MATCH_PARENT, 
        RelativeLayout.LayoutParams.MATCH_PARENT));

  edit.setHint("   YOU CAN WRITE!");
  edit.setTextColor(Color.rgb(200, 0, 0));
  edit.setBackgroundColor(Color.WHITE);
  edit.requestFocus();
  fl = (FrameLayout)activity.findViewById(0x1000);
  fl.addView(edit);
      //Toast.makeText(//if you want tio call the user to write...

      //          mC,

      //          "entrez un texte dans le champ ci-dessus",

      //          Toast.LENGTH_LONG).show();   
}

/*

void setup() {
  Looper.prepare();
}



void draw() {
    String txt = edit.getText().toString();//i you want to save it or transform it
    println(txt); 
}

public void onResume() {
    super.onResume();
    //show the softinput keyboard at start
    act.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
}
*/

}

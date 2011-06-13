package com.dougsko.diceware;


import android.app.Activity;
import android.app.ListActivity;
import android.database.Cursor;
import android.os.Bundle;
import android.widget.SimpleCursorAdapter;

public class Diceware extends Activity {
    /** Called when the activity is first created. */

	private DicewareDbAdapter mDbHelper;
	
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        mDbHelper = new DicewareDbAdapter(this);
        mDbHelper.open();        
        
        
        
    }
    
    private void filldata() {
    	Cursor dicewareCursor = mDbHelper.fetchWord("11111");
        startManagingCursor(dicewareCursor);
        
        String[] from = new String[]{DicewareDbAdapter.KEY_WORD};
        int[] to = new int[]{R.id.output_label};
        
        SimpleCursorAdapter diceware = 
            new SimpleCursorAdapter(this, R.layout.main, dicewareCursor, from, to);
        //setAdapter(diceware);
        
    }
}
package com.dougsko.diceware;


import android.app.Activity;
import android.os.Bundle;

public class Diceware extends Activity {
    /** Called when the activity is first created. */

	private DicewareDbAdapter mDbHelper;
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        mDbHelper = new DicewareDbAdapter(this);
        mDbHelper.open();
        
        
        
        
    }
}
package com.dougsko.diceware;


import android.app.Activity;
import android.database.Cursor;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.SimpleCursorAdapter;
import android.widget.Spinner;
import android.widget.Toast;

public class Diceware extends Activity {
    /** Called when the activity is first created. */

	private DicewareDbAdapter mDbHelper;
	
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        mDbHelper = new DicewareDbAdapter(this);
        mDbHelper.open();
        
        Spinner spinner = (Spinner) findViewById(R.id.spinner);
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(
                this, R.array.modes_array, android.R.layout.simple_spinner_item);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);
        spinner.setOnItemSelectedListener(new MyOnItemSelectedListener());
        
    }
	
	// The callback for the mode selector spinner.
	public class MyOnItemSelectedListener implements OnItemSelectedListener {

	    public void onItemSelected(AdapterView<?> parent,
	        View view, int pos, long id) {
	      Toast.makeText(parent.getContext(), "The mode is " +
	          parent.getItemAtPosition(pos).toString(), Toast.LENGTH_LONG).show();
	    }

	    public void onNothingSelected(AdapterView parent) {
	      // Do nothing.
	    }
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
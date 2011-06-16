package com.dougsko.diceware;


import android.app.Activity;
import android.database.Cursor;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

public class Diceware extends Activity {
    /** Called when the activity is first created. */

	private TextView mOutputText;
	private DicewareDbAdapter mDbHelper;
	private int mode; 
	private String roll;
	
	@Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        roll = "";
        
        mOutputText = (TextView) findViewById(R.id.output);
        Button button_one = (Button) findViewById(R.id.one);
        Button button_two = (Button) findViewById(R.id.two);
        Button button_three = (Button) findViewById(R.id.three);
        Button button_four = (Button) findViewById(R.id.four);
        Button button_five = (Button) findViewById(R.id.five);
        Button button_six = (Button) findViewById(R.id.six);
        Button randomOrg = (Button) findViewById(R.id.randomOrg);
        
        mDbHelper = new DicewareDbAdapter(this);
        mDbHelper.open();
        
        // set up mode spinner
        Spinner spinner = (Spinner) findViewById(R.id.spinner);
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(
                this, R.array.modes_array, android.R.layout.simple_spinner_item);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);
        spinner.setOnItemSelectedListener(new MyOnItemSelectedListener());
        
        
        // button 1 callback
        button_one.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                roll = roll.concat("1");
                checkRoll();
            }            
        });
        
     // button 2 callback
        button_two.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                roll = roll.concat("2");
                checkRoll();
            }            
        });
        
     // button 3 callback
        button_three.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                roll = roll.concat("3");
                checkRoll();
            }            
        });
        
     // button 4 callback
        button_four.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                roll = roll.concat("4");
                checkRoll();
            }            
        });
        
     // button 5 callback
        button_five.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                roll = roll.concat("5");
                checkRoll();
            }            
        });
        
     // button 6 callback
        button_six.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                roll = roll.concat("6");
                checkRoll();
            }            
        });
        
        /** randomOrg button callback
         * http get: http://www.random.org/integers/?num=6&min=1&max=6&col=1&base=10&format=plain&rnd=new
         * get 5 numbers, iterate through them and append each to roll and do checkRoll().
         */
        randomOrg.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
            	String numbers = randomOrgHelper.getNumbers();
            	for(int i = 0; i <= numbers.length(); i++){
            		roll = numbers.substring(0,i);
            		checkRoll();
            		roll = "";
            	}
            }            
        });
    
	}
		
	// The callback for the mode selector spinner.
	public class MyOnItemSelectedListener implements OnItemSelectedListener {
		
		String numberOfRolls;

	    public void onItemSelected(AdapterView<?> parent,
	        View view, int pos, long id) {
	    	switch(pos){
	    	case 0:
	    		numberOfRolls = "5";
	    		break;
	    	case 1:
	    		numberOfRolls = "3";
	    		break;
	    	case 2:
	    		numberOfRolls = "2";
	    		break;
	    	case 3:
	    		numberOfRolls = "2";
	    		break;
	    	}
	    	Toast.makeText(parent.getContext(), "Roll " +
	    			numberOfRolls + " times", Toast.LENGTH_LONG).show();
	      mode = pos;
	      roll = "";
	      mOutputText.setText("");
	    }

	    public void onNothingSelected(AdapterView<?> parent) {
	      // Do nothing.
	    }
	}
    
	// the modes equate to the index of the modes_array in strings.xml
	private void checkRoll(){
		switch (mode) {
		case 0:
			if( roll.length() == 5) {
				getWord();
			}
			break;
		case 1:
			if (roll.length() == 3) {
				getAscii();
			}
			break;
		case 2:
			if ( roll.length() == 2) {
				getAlphaNumeric();
			}
			break;
		case 3:
			if ( roll.substring(0) == "6"){
				Toast.makeText(Diceware.this, "Roll again", Toast.LENGTH_LONG).show();
				roll = "";
				break;
			}
			if(roll.length() == 2){
				String first_digit_string = roll.substring(0, 1);
				String second_digit_string = roll.substring(1);
				
				int first_digit_int = Integer.parseInt(first_digit_string);
				int second_digit_int = Integer.parseInt(second_digit_string);
				
				// is the second roll even? if so, add 5 to first roll. 10 becomes 0.
				if(second_digit_int % 2 == 0){
					int output_int = first_digit_int + 5;
					String output_string = Integer.toString(output_int);
					mOutputText.setText(output_string.substring(output_string.length() - 1));
					roll = "";
				}
				else{
					mOutputText.setText(first_digit_string);
					roll = "";
				}
			}
			break;
		}
	}
	
    private void getWord() {
    	Cursor dicewareCursor = mDbHelper.fetchWord(roll);
        startManagingCursor(dicewareCursor);
        
        mOutputText.setText(dicewareCursor.getString(
        		dicewareCursor.getColumnIndexOrThrow(DicewareDbAdapter.KEY_WORD)));
        
        roll = "";
    }
    
    private void getAlphaNumeric() {
    	Cursor dicewareCursor = mDbHelper.fetchAlphaNumeric(roll);
    	startManagingCursor(dicewareCursor);
    	
    	mOutputText.setText(dicewareCursor.getString(
    			dicewareCursor.getColumnIndexOrThrow(DicewareDbAdapter.KEY_CHAR)));
    	roll = "";
    }
    
    private void getAscii() {
    	Cursor dicewareCursor = mDbHelper.fetchAscii(roll);
    	startManagingCursor(dicewareCursor);
    	
    	String output = dicewareCursor.getString(
    			dicewareCursor.getColumnIndexOrThrow(DicewareDbAdapter.KEY_CHAR));
    	if(output.length() > 1) {
    		Toast.makeText(Diceware.this, "Please roll again", Toast.LENGTH_LONG).show();
    	}
    	else {
    		mOutputText.setText(output);
    	}
    	roll = "";
    }
}
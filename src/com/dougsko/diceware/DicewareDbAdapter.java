package com.dougsko.diceware;


import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;


public class DicewareDbAdapter {
	
	public static final String KEY_NUMBER = "number";
    public static final String KEY_WORD = "word";
    public static final String KEY_ROWID = "_id";
    public static final String KEY_CHAR = "char";

    private static final String TAG = "DicewareDbAdapter";
    private DatabaseHelper mDbHelper;
	private static Context mCtx;
    private static SQLiteDatabase mDb;

    /**
     * Database creation sql statement
     *
    private static final String DATABASE_CREATE =
    	"CREATE TABLE words (_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "
    	+ "number VARCHAR(50), word VARCHAR(50));";
    **/
        

    private static final String DATABASE_PATH = "/data/data/com.dougsko.diceware/databases/";
    private static final String DATABASE_NAME = "diceware.db";
    private static final String DATABASE_TABLE = "words";
    
    private static final int DATABASE_VERSION = 2;

    public static class DatabaseHelper extends SQLiteOpenHelper {

		DatabaseHelper(Context context) {
            super(context, DATABASE_NAME, null, DATABASE_VERSION);
        }

        @Override
        public void onCreate(SQLiteDatabase db) {
            //db.execSQL(DATABASE_CREATE);
        }
        
        @Override
        public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
            Log.w(TAG, "Upgrading database from version " + oldVersion + " to "
                    + newVersion + ", which will destroy all old data");
            db.execSQL("DROP TABLE IF EXISTS words");
            onCreate(db);
        }
        
        // this is crap i copied.
        public void createDataBase() throws IOException{
        	boolean dbExist = checkDataBase();
        	// this is for forcing an update to the database
        	//if(false) {
        	if(dbExist){
        		// do nothing, db exists
        	}
        	else{
        		//By calling this method and empty database will be created into the default system path
                //of your application so we are gonna be able to overwrite that database with our database.
        		this.getReadableDatabase();
        		try {
        			copyDataBase();
        		} 
        		catch (IOException e) {
        			throw new Error("Error copying database");
        		}
        	}
        }
        
        private boolean checkDataBase(){
        	SQLiteDatabase checkDB = null;
        	try{
        		String myPath = DATABASE_PATH + DATABASE_NAME;
        		checkDB = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READONLY);
        	}catch(SQLiteException e){
        		//database does't exist yet.
        	}
        	if(checkDB != null){
        		checkDB.close();
        	}
        	return checkDB != null ? true : false;
        }
    
        private void copyDataBase() throws IOException{
        	//Open your local database as the input stream
        	InputStream myInput = mCtx.getAssets().open(DATABASE_NAME);
        	// Path to the just created empty database
        	String outFileName = DATABASE_PATH + DATABASE_NAME;
        	
        	//Open the empty db as the output stream
        	OutputStream myOutput = new FileOutputStream(outFileName);
        	
        	//transfer bytes from the input file to the output file
        	byte[] buffer = new byte[1024];
        	int length;
        	while ((length = myInput.read(buffer))>0){
        		myOutput.write(buffer, 0, length);
        	}
     
        	//Close the streams
        	myOutput.flush();
        	myOutput.close();
        	myInput.close();
        }
        
        public void openDataBase() throws SQLException{
        	//Open the database
            String myPath = DATABASE_PATH + DATABASE_NAME;
        	mDb = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READONLY);
        	
        }
    }
    
    /**
     * Constructor - takes the context to allow the database to be
     * opened/created
     * 
     * @param ctx the Context within which to work
     */
    public DicewareDbAdapter(Context ctx) {
        DicewareDbAdapter.mCtx = ctx;
    }

    /**
     * Open the diceware database. If it cannot be opened, try to create a new
     * instance of the database. If it cannot be created, throw an exception to
     * signal the failure
     * 
     * @return this (self reference, allowing this to be chained in an
     *         initialization call)
     * @throws SQLException if the database could be neither opened or created
     */
    public DicewareDbAdapter open() throws SQLException {
        mDbHelper = new DatabaseHelper(mCtx);
        //mDb = mDbHelper.getReadableDatabase();
        
        // this is mine
        try {
        	mDbHelper.createDataBase();
        } catch (IOException ioe) {
        	throw new Error("Unable to create database");
        }
        try {
        	mDbHelper.openDataBase();
        }catch(SQLException sqle){
        	throw sqle;
        }
        return this;
    }
    
    public void close() {
        mDbHelper.close();
    }
    
    
    /**
     * Return a Cursor positioned at the note that matches the given rowId
     * 
     * @param roll id of note to retrieve
     * @return Cursor positioned to matching note, if found
     * @throws SQLException if note could not be found/retrieved
     * 
     * Do this SQL statement:
     *   select word from words where number = 11112;
     */
    public Cursor fetchWord(String roll) throws SQLException {

        Cursor mCursor =

            mDb.query(true, "words", new String[] {KEY_NUMBER, KEY_WORD},
                     KEY_NUMBER + "=" + roll, null, null, null, null, null);
        if (mCursor != null) {
            mCursor.moveToFirst();
        }
        return mCursor;

    }
    
    public Cursor fetchAlphaNumeric(String roll) throws SQLException {
    	Cursor mCursor =
    		mDb.query(true, "alphanumerics", new String[] {KEY_NUMBER, KEY_CHAR},
    				KEY_NUMBER + "=" + roll, null, null, null, null, null);
    	if (mCursor != null) {
    		mCursor.moveToFirst();
    	}
    	return mCursor;
    }
    
    public Cursor fetchNumber(String roll) throws SQLException {
    	Cursor mCursor =
    		mDb.query(true, "numbers", new String[] {KEY_NUMBER, KEY_CHAR},
    				KEY_NUMBER + "=" + roll, null, null, null, null, null);
    	if (mCursor != null) {
    		mCursor.moveToFirst();
    	}
    	return mCursor;
    }
    

}

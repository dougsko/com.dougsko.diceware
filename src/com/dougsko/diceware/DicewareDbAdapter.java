package com.dougsko.diceware;


//import java.io.FileOutputStream;
//import java.io.IOException;
//import java.io.InputStream;
//import java.io.OutputStream;

import android.content.Context;
//import android.content.res.AssetManager;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
//import android.database.sqlite.SQLiteException;
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
    
    private static final String DATABASE_NAME = "diceware.db";
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
        
        public void openDataBase() throws SQLException{
        	//Open the database
            //String myPath = DATABASE_PATH + DATABASE_NAME;
            String myPath = mCtx.getFilesDir().getPath().replace("files", "databases/") + DATABASE_NAME;
            Log.d(TAG, "myPath = " + myPath);
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
    
    public Cursor fetchAscii(String roll) throws SQLException {
    	Cursor mCursor =
    		mDb.query(true, "asciis", new String[] {KEY_NUMBER, KEY_CHAR},
    				KEY_NUMBER + "=" + roll, null, null, null, null, null);
    	if (mCursor != null) {
    		mCursor.moveToFirst();
    	}
    	return mCursor;
    }
    

}

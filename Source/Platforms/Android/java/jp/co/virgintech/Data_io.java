
package jp.co.virgintech.virgintech5stproject;

import android.app.Activity;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

public class Data_io
{    
    static public void initialize_Preferences()
    {
    }
    static public void save_Coin_Value(int value)
    {
        /*SharedPreferences pref = getSharedPreferences("iodata",MODE_PRIVATE);
        Editor e = pref.edit();
        e.putInt("coin", value);
        e.commit();*/
    }
    static public int load_Coin_Value()
    {
        int value=0;
        /*SharedPreferences pref = getSharedPreferences("iodata", MODE_PRIVATE);
        value = pref.getInt("coin", 0);*/
        return value;
    }
}
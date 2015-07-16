
package jp.co.virgintech.virgintech5stproject;

import android.app.Activity;
import android.content.Context;
//import android.content.res.Resources;
import android.preference.PreferenceManager;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

public class Data_io
{
    static public void initialize_Preferences()
    {
    }
    static public void save_Coin_Value(Context context,int value)
    {
        SharedPreferences pref = PreferenceManager.getDefaultSharedPreferences(context);
        Editor e = pref.edit();
        e.putInt("coin", value);
        e.commit();
    }
    static public int load_Coin_Value(Context context)
    {
        int value;
        SharedPreferences pref = PreferenceManager.getDefaultSharedPreferences(context);
        value = pref.getInt("coin", 0);
        return value;
    }
    static public void save_Int_Value(Context context,String file,String key,int value)
    {
        SharedPreferences pref = context.getSharedPreferences(file, context.MODE_PRIVATE);
        Editor e = pref.edit();
        e.putInt(key, value);
        e.commit();
    }
    static public int load_Int_Value(Context context,String file,String key)
    {
        int value;
        SharedPreferences pref = context.getSharedPreferences(file, context.MODE_PRIVATE);
        value = pref.getInt(key, 0);
        return value;
    }
    static public void getResText(Context context,String type,String key)
    {
        /* Use Resources-Class
         Resources res = context.getResources();
        int resId = res.getIdentifier(key, "string", context.getPackageName());
        String str = res.getString(resId);
         */
        
        //Use Context-Class
        int resId = context.getResources().getIdentifier(key, type, context.getPackageName());
        String str = context.getString(resId);
        
        //CallBack Return!
        callbackStrings(str);
    }
    
    static private native void callbackStrings(String message);
}


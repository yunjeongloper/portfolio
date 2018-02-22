package com.devunlimit.project.util.exceptions;

public class CheckNull {

  public static boolean isEmpty( Object obj ) {
    if ( obj == null || obj.toString().equals( "" ) ) return true;
    return false;
  }

}

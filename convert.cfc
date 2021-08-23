component {
  public function init(){
    return this;
  }
  
  /**
  * For Hibernate 5.4+, convert legacy-style positional parameters to JPA-syntax.
  * Uses Java regex library since neither Lucee nor ACF offer modern regex support.
  *
  * @hql Hibernate Query Language string to make safe for Hibernate v5.4+.
  * @see https://hibernate.atlassian.net/browse/HHH-12101
  */
  private string function convertToJPA( required string hql ){
      var matchJDBCPositionalParameters = "(?<![?])\?(?!\?)(?![^?=]*['\""])(?!\d)";
      var javaPattern = createObject( "java", "java.util.regex.Pattern" );
      var matcher = javaPattern.compile( matchJDBCPositionalParameters).matcher( arguments.hql );
      if ( !matcher.find() ){
          return arguments.hql;
      }
      var matches = matcher.replaceAll( "<REPLACE><<PARAMATER>>" );
      return listToArray( matches, "<<PARAMATER>>", false, true )
                  .map( function( part, index ){
                      return replace( part, "<REPLACE>", "?#index#" );
                  } )
                  .toList( "" );
  }


}

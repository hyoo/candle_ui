module Request.Helpers exposing (apiUrl)


apiUrl : String -> String 
apiUrl str =
    "http://localhost:3301/" ++ str
global Class ReferLitify {

  webservice static void createReferral(String intakeId) {
    String auth = getAuth(); 
    System.debug(getAuth());

    Intake__c intake = [Select Id, Name From Intake__c Where Id = :intakeId];
    String refResponse = sendIntake(intake, auth);      
    
    // -- doesn't work correctly from here -- 
    Referral__c ref = new Referral__c(); 
    // makes the association between ref and intake. 
    ref.Intake__c = (Id)intakeId; 
    
    //parse JSON string and set referral fields
    //insert ref
    insert ref; 
  }
  
  global static String sendIntake(Intake__c intake, String auth) {
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/json');
    req.setHeader('Accept', 'application/json');
    
    req.setHeader('X-User-Access-Token', auth);
    System.debug(auth);
    req.setEndpoint('https://referral-api-dev.herokuapp.com/api/v1/referral_intakes'); 
    req.setBody('{"client_first_name": "'+intake.Name+'"}'); 
    
    HttpResponse res;
    res = h.send(req);
    System.debug(res.getBody());

    return res.getBody();
  }

  global static String getAuth() {

    Http h = new Http();
    HttpRequest req = new HttpRequest();
    
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/json');
    req.setHeader('Accept', 'application/json');
    
    //hardcoded api, ideally would have retrieved from custom setting config
    req.setEndpoint('https://referral-api-dev.herokuapp.com/api/v1/authenticate'); 
    //hardcoded email and password, would be stored in an encrypted field. Not sure, if this can be done on the USER record. 
    req.setBody('{"email": "raosushant@gmail.com", "password": "kAId9xwn7EcT"}'); 
    
    HttpResponse res;
    res = h.send(req);
    return res.getHeader('X-User-Access-Token');
  }
}
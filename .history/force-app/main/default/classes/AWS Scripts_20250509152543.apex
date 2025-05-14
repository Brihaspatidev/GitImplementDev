//********************************************** Archival scripts ************************************************************ 

 

//Historical Balance Archival Script <Start> 

List<Bank_Account__c> bankAccList = [SELECT Id, Opportunity__c, Opportunity__r.CreatedDate FROM Bank_Account__c  

                                        WHERE Id IN (SELECT Bank_Account__c FROM Historical_Balance__c WHERE Bank_Account__c != NULL)   


                                        AND calendar_month(createddate)>=11  

                                        AND calendar_month(createddate)<=12  

                                        AND Calendar_year(createddate)=2024  

                                        ORDER BY CreatedDate ASC];  

Integer timeDelay = 6;  

DateTime sysTime = DateTime.Now().addSeconds(timeDelay);  

String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();  

System.schedule('Plaid Archival Record Id : '+bankAccList[0].Id+' Historical_Balance__c', chron_exp, new AWS_PlaidArchivalSchedulable(bankAccList, 'Historical_Balance__c', timeDelay)); 

//Historical Balance Archival Script <End> 

 

 

//Bank Transaction Archival Script <Start> 

List<Bank_Account__c> bankAccList = [SELECT Id, Opportunity__c, Opportunity__r.CreatedDate FROM Bank_Account__c  

                                        WHERE Id IN (SELECT Bank_Account__c FROM Bank_Transaction__c WHERE Bank_Account__c != NULL)   

                                        AND AWS_Bank_Transaction_Path__c=NULL   

                                        AND calendar_month(createddate)>=11 AND calendar_month(createddate)<=12  

                                        AND Calendar_year(createddate)=2024  

                                        ORDER BY CreatedDate ASC];  

 

Integer timeDelay = 6;  

DateTime sysTime = DateTime.Now().addSeconds(timeDelay);  

String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();  

System.schedule('Plaid Archival Record Id : '+bankAccList[0].Id+' Bank_Transaction__c', chron_exp, new AWS_PlaidArchivalSchedulable(bankAccList, 'Bank_Transaction__c', timeDelay));  

//Bank Transaction Archival Script <End> 

 

 

//OCR Data Archival Script <Start> 

List<OCR_Bank_Detail__c> ocrBankAccList = [SELECT Id,Opportunity__c, Opportunity__r.Createddate FROM OCR_Bank_Detail__c   

                                                WHERE RecordType.Name ='Bank Account' 

                                                AND AWS_Transaction_Path__c = NULL 

                                                AND Value_Source__c != 'Manual' 

                                                AND Opportunity__c != NULL 

                                                AND CALENDAR_YEAR(Createddate) = 2024 

                                                AND CALENDAR_MONTH(CreatedDate) <= 12  

                                                AND CALENDAR_MONTH(CreatedDate) >= 11 

                                                ORDER BY CreatedDate ASC];  

Integer timeDelay = 6;  

DateTime sysTime = DateTime.Now().addSeconds(timeDelay);  

String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();  

System.schedule('New OCR Archival Record Id : '+ocrBankAccList[0].Id, chron_exp, new AWS_NewOCRArchivalSchedulable(ocrBankAccList,timeDelay));  

//OCR Data Archival Script <End> 

 

 

//OCR Data Archival After Pause Script <Start> 

List<OCR_Bank_Detail__c> ocrBankAccList = [SELECT Id,Opportunity__c, Opportunity__r.Createddate FROM OCR_Bank_Detail__c  

                                                WHERE RecordType.Name ='Bank Account'  

                                                AND AWS_Transaction_Path__c = NULL  

                                                AND Value_Source__c != 'Manual'  

                                                AND Opportunity__c != NULL  

                                                AND CALENDAR_YEAR(Createddate) = 2024  

                                                AND CALENDAR_Month(CreatedDate) <=12  

                                                AND CALENDAR_Month(CreatedDate) >=11  

                                                AND DAY_ONLY(CreatedDate) >= 2024-02-20  

                                                ORDER BY CreatedDate ASC];  

Integer timeDelay = 6;  

Set<Id> oppIds = (new Map<Id,Opportunity>([SELECT Id FROM Opportunity  

                                                WHERE Id IN (SELECT Opportunity__c FROM OCR_Bank_Detail__c  

                                                                WHERE RecordType.Name ='Bank Account'  

                                                                AND AWS_Transaction_Path__c != NULL  

                                                                AND Value_Source__c != 'Manual'  

                                                                AND Opportunity__c != NULL  

                                                                AND CALENDAR_YEAR(createdDate) = 2024  

                                                                AND CALENDAR_MONTH(createdDate) <=12  

                                                                AND CALENDAR_MONTH(createdDate) >=11)])).keySet().clone();  

 

DateTime sysTime = DateTime.Now().addSeconds(timeDelay);  

String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();  

System.schedule('New OCR Archival Record Id : '+ocrBankAccList[0].Id, chron_exp, new AWS_NewOCRArchivalSchedulable(ocrBankAccList,oppIds,timeDelay));  

//OCR Data Archival After Pause Script <End> 

 

 

 

 

 

 

//********************************************** Deletion scripts ************************************************************ 

 

//Historical Balance Deletion Script <Start> 

String query = 'SELECT Id';  

        query += ' FROM Historical_balance__c';  

        query += ' WHERE Bank_Account__c NOT IN: recordIdsToAvoid';  

        query += ' AND Bank_Account__r.Opportunity__c NOT IN: recordIdsToAvoid';  

        query += ' AND Bank_Account__r.AWS_Historical_Balance_Path__c != NULL';  

        query += ' AND CALENDAR_YEAR(Bank_Account__r.CreatedDate) = 2024';  

        query += ' AND CALENDAR_MONTH(Bank_Account__r.CreatedDate) >= 11';  

        query += ' AND CALENDAR_MONTH(Bank_Account__r.CreatedDate) <= 12';  

        query += ' ORDER BY CreatedDate ASC';  

 

AWS_DataDeleteBatch batchObj = new AWS_DataDeleteBatch('Bank_Account__c', query);  

Database.executeBatch(batchObj,1000);  

//Historical Balance Deletion Script <End> 

 

 

//Bank Transaction Deletion Script <Start> 

String query = 'SELECT Id';  

        query += ' FROM Bank_Transaction__c';  

        query += ' WHERE Bank_Account__c NOT IN: recordIdsToAvoid';  

        query += ' AND Bank_Account__r.Opportunity__c NOT IN: recordIdsToAvoid';  

        query += ' AND Bank_Account__r.AWS_Bank_Transaction_Path__c != NULL';  

        query += ' AND CALENDAR_YEAR(Bank_Account__r.CreatedDate) = 2024';  

        query += ' AND CALENDAR_MONTH(Bank_Account__r.CreatedDate) >= 11';  

        query += ' AND CALENDAR_MONTH(Bank_Account__r.CreatedDate) <= 12';  

        query += ' ORDER BY CreatedDate ASC';  

        system.debug(query);  

 

AWS_DataDeleteBatch batchObj = new AWS_DataDeleteBatch('Bank_Account__c', query);  

Database.executeBatch(batchObj,1000);  

//Bank Transaction Deletion Script <End> 

 

 

//OCR Data Deletion Script <Start> 

String query = 'SELECT Id';  

        query += ' FROM Transaction__c';  

        query += ' WHERE OCR_Bank_Detail__r.OCR_Bank_Account__r.AWS_Transaction_Path__c != NULL';  

        query += ' AND CALENDAR_YEAR(OCR_Bank_Detail__r.OCR_Bank_Account__r.CreatedDate) = 2024';  

        query += ' AND CALENDAR_MONTH(OCR_Bank_Detail__r.OCR_Bank_Account__r.CreatedDate) >= 11';  

        query += ' AND CALENDAR_MONTH(OCR_Bank_Detail__r.OCR_Bank_Account__r.CreatedDate) <=12';  

        query += ' ORDER BY OCR_Bank_Detail__r.OCR_Bank_Account__r.CreatedDate ASC';  

  

AWS_DataDeleteBatch batchObj = new AWS_DataDeleteBatch('OCR_Bank_Detail__r.OCR_Bank_Account__c', query);  

Database.executeBatch(batchObj,1000); 

//OCR Data Deletion Script <End> 

 

 

 

 

 

 

 

 

//***************************************** Archival scripts with 1.5 hours delay ********************************************************* 

 

//Historical Balance Archival Script <Start> 

List<Bank_Account__c> bankAccList = [SELECT Id, Opportunity__c, Opportunity__r.CreatedDate FROM Bank_Account__c  

                                        WHERE Id IN (SELECT Bank_Account__c FROM Historical_Balance__c WHERE Bank_Account__c != NULL)   

                                        AND AWS_Historical_Balance_Path__c=NULL   

                                        AND calendar_month(createddate)>=11  

                                        AND calendar_month(createddate)<=12  

                                        AND Calendar_year(createddate)=2024  

                                        ORDER BY CreatedDate ASC];  

Integer timeDelay = 6;  

DateTime sysTime = DateTime.Now().addMinutes(90);  

String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();  

System.schedule('Plaid Archival Record Id : '+bankAccList[0].Id+' Historical_Balance__c', chron_exp, new AWS_PlaidArchivalSchedulable(bankAccList, 'Historical_Balance__c', timeDelay)); 

//Historical Balance Archival Script <End> 

 

 

//Bank Transaction Archival Script <Start> 

List<Bank_Account__c> bankAccList = [SELECT Id, Opportunity__c, Opportunity__r.CreatedDate FROM Bank_Account__c  

                                        WHERE Id IN (SELECT Bank_Account__c FROM Bank_Transaction__c WHERE Bank_Account__c != NULL)   

                                        AND AWS_Bank_Transaction_Path__c=NULL   

                                        AND calendar_month(createddate)>=11 AND calendar_month(createddate)<=12  

                                        AND Calendar_year(createddate)=2024  

                                        ORDER BY CreatedDate ASC];  

 

Integer timeDelay = 6;  

DateTime sysTime = DateTime.Now().addMinutes(90);  

String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();  

System.schedule('Plaid Archival Record Id : '+bankAccList[0].Id+' Bank_Transaction__c', chron_exp, new AWS_PlaidArchivalSchedulable(bankAccList, 'Bank_Transaction__c', timeDelay));  

//Bank Transaction Archival Script <End> 

 

 

//OCR Data Archival Script <Start> 

List<OCR_Bank_Detail__c> ocrBankAccList = [SELECT Id,Opportunity__c, Opportunity__r.Createddate FROM OCR_Bank_Detail__c   

                                                WHERE RecordType.Name ='Bank Account' 

                                                AND AWS_Transaction_Path__c = NULL 

                                                AND Value_Source__c != 'Manual' 

                                                AND Opportunity__c != NULL 

                                                AND CALENDAR_YEAR(Createddate) = 2024 

                                                AND CALENDAR_MONTH(CreatedDate) <= 12  

                                                AND CALENDAR_MONTH(CreatedDate) >= 11 

                                                ORDER BY CreatedDate ASC];  

Integer timeDelay = 6;  

DateTime sysTime = DateTime.Now().addMinutes(90); 

String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();  

System.schedule('New OCR Archival Record Id : '+ocrBankAccList[0].Id, chron_exp, new AWS_NewOCRArchivalSchedulable(ocrBankAccList,timeDelay));  

//OCR Data Archival Script <End> 

 

//OCR Data Archival After Pause Script <Start> 

List<OCR_Bank_Detail__c> ocrBankAccList = [SELECT Id,Opportunity__c, Opportunity__r.Createddate FROM OCR_Bank_Detail__c  

                                                WHERE RecordType.Name ='Bank Account'  

                                                AND AWS_Transaction_Path__c = NULL  

                                                AND Value_Source__c != 'Manual'  

                                                AND Opportunity__c != NULL  

                                                AND CALENDAR_YEAR(Createddate) = 2024  

                                                AND CALENDAR_Month(CreatedDate) <=12  

                                                AND CALENDAR_Month(CreatedDate) >=11  

                                                AND DAY_ONLY(CreatedDate) >= 2024-02-20  

                                                ORDER BY CreatedDate ASC];  

Integer timeDelay = 6;  

Set<Id> oppIds = (new Map<Id,Opportunity>([SELECT Id FROM Opportunity  

                                                WHERE Id IN (SELECT Opportunity__c FROM OCR_Bank_Detail__c  

                                                                WHERE RecordType.Name ='Bank Account'  

                                                                AND AWS_Transaction_Path__c != NULL  

                                                                AND Value_Source__c != 'Manual'  

                                                                AND Opportunity__c != NULL  

                                                                AND CALENDAR_YEAR(createdDate) = 2024  

                                                                AND CALENDAR_MONTH(createdDate) <=12  

                                                                AND CALENDAR_MONTH(createdDate) >=11)])).keySet().clone();  

 

DateTime sysTime = DateTime.Now().addMinutes(90); 

String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();  

System.schedule('New OCR Archival Record Id : '+ocrBankAccList[0].Id, chron_exp, new AWS_NewOCRArchivalSchedulable(ocrBankAccList,oppIds,timeDelay));  

//OCR Data Archival After Pause Script <End> 

 
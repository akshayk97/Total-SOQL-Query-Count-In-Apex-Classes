List<ApexClass> classes = [select body,Name, NamespacePrefix from ApexClass];

map<String,Integer> classLOCmap = new map<String,Integer>();
List<String> strlst = new List<String>();
String substra;                     
String substrb;
integer totalQuery = 0;
for (ApexClass cls : classes){
    if(cls.body != '(hidden)'){
        String[] lines = cls.body.split('\n');
        for(String str:lines){
            if(String.isNotBlank(str)){
                if(!str.trim().startsWith('//')){
                    if(!str.containsIgnoreCase('System.debug')){
                        if(str.containsIgnoreCase('FROM ')){
                            totalQuery += 1;
                            substra = str.substringAfter('FROM ');                        
                            substrb = substra.substringBefore(' ');
             
                            if(!classLOCmap.containsKey(substrb.tolowerCase())){
                                classLOCmap.put(substrb.tolowerCase(),1);
                            }
                            else{
                                integer i = 0;
                                i = classLOCmap.get(substrb.tolowerCase()) + 1;
                                classLOCmap.put(substrb.tolowerCase(), i);
                            }
                        }   
                    }
                }
            }
        }
    }
}
System.debug('totalQuery: ' + totalQuery);
System.debug('json result ' + json.serialize(classLOCmap));

public class CaseService 
{
    public static void closeCases(Set<ID> cases, String closeReason)
    {
        System.debug('SKA - ' + cases);
        System.debug('SKA - ' + closeReason);
        List<Case> caseToUpdate = new List<Case>();
        for (Id caseId : cases)
        {
            Case c = new Case(Id = caseId);
            c.Reason = closeReason;
            c.Status = 'Closed'; 
            
            caseToUpdate.add(c);
        }
     
        update caseToUpdate;
        
    }
}
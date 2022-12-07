public class Assignments {
    private static final String VOTER_RECORD_TYPE_NAME = 'Voter';
    private static final String MODERATOR_RECORD_TYPE_NAME = 'Moderator';
    private static final String CONFIGURATOR_RECORD_TYPE_NAME = 'Configurator';
    private static final String ANALYST_RECORD_TYPE_NAME = 'Analyst';
    private Map<String, List<Id>> userIdsLookup = new Map<String, List<Id>>();

    public Assignments(
        List<Id> voters,
        List<Id> moderators,
        List<Id> configurators,
        List<Id> analysts) 
    {
        this.Voters = voters;
        this.Moderators = moderators;
        this.Configurators = configurators;
        this.Analysts = analysts;

        userIdsLookup.put(VOTER_RECORD_TYPE_NAME, Voters);
        userIdsLookup.put(MODERATOR_RECORD_TYPE_NAME, Moderators);
        userIdsLookup.put(CONFIGURATOR_RECORD_TYPE_NAME, Configurators);
        userIdsLookup.put(ANALYST_RECORD_TYPE_NAME, Analysts);
    }

    public final List<Id> Voters { get; private set; }

    public final List<Id> Moderators { get; private set; }

    public final List<Id> Configurators { get; private set; }

    public final List<Id> Analysts { get; private set; }

    public List<String> GetUserTypesForAvailableData(){
        List<String> userTypes = new List<String>();

        if (Voters != null){
            userTypes.add(VOTER_RECORD_TYPE_NAME);
        }

        if (Moderators != null){
            userTypes.add(MODERATOR_RECORD_TYPE_NAME);
        }

        if (Configurators != null){
            userTypes.add(CONFIGURATOR_RECORD_TYPE_NAME);
        }

        if (Analysts != null){
            userTypes.add(ANALYST_RECORD_TYPE_NAME);
        }

        return userTypes;
    }

    public List<Id> GetUserIds(String userType){
        return userIdsLookup.get(userType);
    }
}

public class Eins_IntentModel {

	public ProbabilityItem[] probabilities;
	//public String object;	//predictresponse
	public class ProbabilityItem {
		public ProbabilityItem() {
			this.probability = 0;
			this.label = '';
		}
		public String label;	//Password Help
		public Double probability;	//0.99040705
	}

    public static Eins_IntentModel parseFromJSON(string jsonString) {
        Eins_IntentModel data = (Eins_IntentModel)JSON.deserialize(jsonString, Eins_IntentModel.class);
        return data;
    }

}
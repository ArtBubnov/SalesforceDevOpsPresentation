@isTest
public class Eins_IntentModel_Test {
    @isTest
    static void testParse() {
		String json=		'{'+
		'    "probabilities": ['+
		'        {'+
		'            "label": "Not An Online Product",'+
		'            "probability": 0.99040705'+
		'        },'+
		'        {'+
		'            "label": "Don\'t Understand How To Do This Online",'+
		'            "probability": 0.003532466'+
		'        },'+
		'    ],'+
		'    "object": "predictresponse"'+
		'}';
		Eins_IntentModel obj = Eins_IntentModel.parseFromJSON(json);
		System.assert(obj != null);
	}
}
@IsTest
private class CompApp_Ctrl_RedirectHelperTest {
    static testMethod void testRedirect() {
        CompApp_Ctrl_RedirectHelper helper = new CompApp_Ctrl_RedirectHelper();
        PageReference pageRef = helper.redirect();
        System.assertNotEquals(null, pageRef);
        System.assertEquals('/noAccess',pageRef.getUrl());
    }
}
codeunit 50150 "HW Hello World Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        gcuLibraryAssert: Codeunit "Library Assert";
        gExpectedCaption: Text;

    [Test]
    [HandlerFunctions('HelloMessageHandler')]
    procedure GreetNamesQASetupTable()
    var
        lQASetup: Record "PB365 QA Setup";
        lcuHelloWorld: Codeunit "HW Hello World";
    begin
        // [GIVEN] The caption of the QA setup table of Yaveon 365 Quality Assurance
        gExpectedCaption := lQASetup.TableCaption();
        // [WHEN] The greeting is shown
        lcuHelloWorld.Greet();
        // [THEN] The message names the QA setup table - checked in HelloMessageHandler
    end;

    [MessageHandler]
    procedure HelloMessageHandler(piMessage: Text[1024])
    begin
        gcuLibraryAssert.IsTrue(piMessage.Contains(gExpectedCaption), 'The greeting does not name the QA setup table.');
    end;
}

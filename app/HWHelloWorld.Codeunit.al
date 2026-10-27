codeunit 50100 "HW Hello World"
{
    procedure Greet()
    var
        lQASetup: Record "PB365 QA Setup";
        lctxHelloMsg: Label 'Hello world - built against %1.', Comment = '%1 = table caption of the QA setup';
    begin
        Message(lctxHelloMsg, lQASetup.TableCaption());
    end;
}

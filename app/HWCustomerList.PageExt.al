pageextension 50100 "HW Customer List" extends "Customer List"
{
    trigger OnOpenPage()
    var
        lcuHelloWorld: Codeunit "HW Hello World";
    begin
        lcuHelloWorld.Greet();
    end;
}

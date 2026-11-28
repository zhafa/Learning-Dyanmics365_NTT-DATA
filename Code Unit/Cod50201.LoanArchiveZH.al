codeunit 50201 LoanArchive_ZH
{
    procedure ArchiveLoan(var LoanHeader: Record LoanHeader_ZH)
    var
    LoanLine: Record LoanLine_ZH;
    PostedHeader: Record PostedLoanHeader_ZH;
    PostedLine: Record PostedLoanLine_ZH;
    begin
        PostedHeader.Init();
        PostedHeader.TransferFields(LoanHeader);
        PostedHeader.Insert();

        LoanLine.SetRange("Document no.",LoanHeader."No.");
        if LoanLine.FindSet() then 
            repeat
                PostedLine.Init();
                PostedLine.TransferFields(LoanLine);
                PostedLine.Insert();
            until LoanLine.Next() = 0;

        LoanLine.DeleteAll(false);
        LoanHeader.Delete(false);
    end;

}


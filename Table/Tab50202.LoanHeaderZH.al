table 50202 LoanHeader_ZH
{
    Caption = 'Loan Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Employee; Code[20])
        {
            Caption = 'Employee';
            TableRelation = Employee."No.";
        }
        field(3; LoanDate; Date)
        {
            Caption = 'Loan Date';

            trigger OnValidate()
            begin
                CheckDates();
            end;
        }
        field(4; "Expected Return Date"; Date)
        {
            Caption = 'Expected Return Date';

            trigger OnValidate()
            begin
                CheckDates();
            end;
        }
        field(5; Status; Enum "LoanHeaderStatus_ZH")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(6; "Actual Return Date"; Date)
        {
            Caption = 'Actual Return Date';
            Editable = false;
        }
        field(8; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        EquipmentSetup: Record EquipmentSetup_ZH;
        NoSeries: Codeunit "No. Series";
        SetupErr: Label 'Loan Nos. must be specified in Equipment Setup before new loans can be created.';
    begin
        if "No." = '' then begin
            EquipmentSetup.GetSetup();
            if EquipmentSetup."Loan Nos." = '' then
                Error(SetupErr);
            "No. Series" := EquipmentSetup."Loan Nos.";
            "No." := NoSeries.GetNextNo("No. Series", WorkDate());
        end;
        if LoanDate = 0D then
            LoanDate := WorkDate();
    end;

    trigger OnDelete()
    var
        LoanLine: Record LoanLine_ZH;
        DeleteErr: Label 'Loan %1 cannot be deleted because its status is %2. Reopen the loan first.';
    begin
        if Status <> Status::Open then
            Error(DeleteErr, "No.", Status);

        LoanLine.SetRange("Document no.", "No.");
        LoanLine.DeleteAll(true);
    end;

    local procedure CheckDates()
    var
        DateErr: Label '%1 cannot be earlier than %2.';
    begin
        if (LoanDate <> 0D) and ("Expected Return Date" <> 0D) then
            if "Expected Return Date" < LoanDate then
                Error(DateErr, FieldCaption("Expected Return Date"), FieldCaption(LoanDate));
    end;

    procedure Release()
    var
        LoanLine: Record LoanLine_ZH;
        NotOpenErr: Label 'Loan %1 cannot be released because its status is %2.';
        MissingErr: Label '%1 must be filled in before the loan can be released.';
        NoLinesErr: Label 'Add at least one line before releasing the loan.';
    begin
        if Status <> Status::Open then
            Error(NotOpenErr, "No.", Status);
        if Employee = '' then
            Error(MissingErr, FieldCaption(Employee));
        if LoanDate = 0D then
            Error(MissingErr, FieldCaption(LoanDate));
        if "Expected Return Date" = 0D then
            Error(MissingErr, FieldCaption("Expected Return Date"));

        LoanLine.SetRange("Document no.", "No.");
        if LoanLine.IsEmpty() then
            Error(NoLinesErr);

        Status := Status::Released;
        Modify(true);
    end;

    procedure Reopen()
    var
        NotReleasedErr: Label 'Loan %1 cannot be reopened because its status is %2. Only released loans can be reopened.';
    begin
        if Status <> Status::Released then
            Error(NotReleasedErr, "No.", Status);

        Status := Status::Open;
        Modify(true);
    end;
}
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

    // fitur untuk merubah status dari Open menjadi Released
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

        CheckEquipmentNotOnLoan();
        UpdateEquipmentStatus(Enum::EquipmentStatus_ZH::"Loan");

        Status := Status::Released;
        Modify(true);
    end;
    // Fitur untuk membatalkan status Released menjadi Open
    procedure Reopen()
    var
        NotReleasedErr: Label 'Loan %1 cannot be reopened because its status is %2. Only released loans can be reopened.';
    begin
        if Status <> Status::Released then
            Error(NotReleasedErr, "No.", Status);
        
        UpdateEquipmentStatus(Enum::EquipmentStatus_ZH::Available);

        Status := Status::Open;
        Modify(true);
    end;

    // Membalikkan status
    procedure return()
    var
        NotReleasedErr: Label 'Loan %1 cannot be returned because its status is %2. Only released loans can be returned.';
    begin
        if Status <> Status::Released then
            Error(NotReleasedErr, "No.", Status);
        UpdateEquipmentStatus(Enum::EquipmentStatus_ZH::Available);

        Status := Status::Returned;
        "Actual Return Date" := WorkDate();
        Modify(true);
    end;

    // Seleksi Equipment yang sedang dipinjam
    local procedure CheckEquipmentNotOnLoan()
    var
        LoanLine: Record LoanLine_ZH;
        Equipment: Record Equipment_ZH;
        OnLoanErr: Label 'Equipment %1 is already on loan and cannot be released in this loan. Remove it from the lines or wait until it is returned.';
    begin
        LoanLine.SetRange("Document no.", "No.");
        if LoanLine.FindSet() then
            repeat
                Equipment.Get(LoanLine."EquipmentCode");
                if Equipment.Status = Equipment.Status::"Loan" then
                    Error(OnLoanErr, Equipment."Code");
            until LoanLine.Next() = 0;
    end;

    // Update status Equipment
    local procedure UpdateEquipmentStatus(NewStatus: Enum "EquipmentStatus_ZH")
    var
        LoanLine : Record LoanLine_ZH;
        Equipment : Record Equipment_ZH;
    begin
        LoanLine.SetRange("Document no.", "No.");
        if LoanLine.FindSet() then
            repeat
              if  Equipment.Get(LoanLine."EquipmentCode") then begin
                    Equipment.Status := NewStatus;
                    Equipment.Modify(true);
                end;
            until LoanLine.Next() = 0;
    end;
}
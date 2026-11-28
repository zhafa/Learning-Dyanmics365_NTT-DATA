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

        // Merubah Employee sesuai dengan standar BC
        field(2; Employee; Code[20])
        {
            Caption = 'Employee';
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                CreateDimFromEmployee();
            end;


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
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2), Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim();
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
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
        UpdateEquipmentStatus(Enum::EquipmentStatus_ZH::"Loan", Employee);

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
        
        UpdateEquipmentStatus(Enum::EquipmentStatus_ZH::Available,'');

        Status := Status::Open;
        Modify(true);
    end;

    // Membalikkan status
    procedure return()
    var
        NotReleasedErr: Label 'Loan %1 cannot be returned because its status is %2. Only released loans can be returned.';
        ProcArchive: Codeunit LoanArchive_ZH;
    begin
        if Status <> Status::Released then
            Error(NotReleasedErr, "No.", Status);
        UpdateEquipmentStatus(Enum::EquipmentStatus_ZH::Available,'');

        Status := Status::Returned;
        "Actual Return Date" := WorkDate();
        ProcArchive.ArchiveLoan(Rec);
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
    local procedure UpdateEquipmentStatus(NewStatus: Enum EquipmentStatus_ZH; NewHolder: Code[20])
    var
        LoanLine : Record LoanLine_ZH;
        Equipment : Record Equipment_ZH;
    begin
        LoanLine.SetRange("Document no.", "No.");
        if LoanLine.FindSet() then
            repeat
              if  Equipment.Get(LoanLine."EquipmentCode") then begin
                    Equipment.Status := NewStatus;
                    Equipment."Current Holder" := NewHolder;
                    Equipment.Modify(true);
                end;
            until LoanLine.Next() = 0;
    end;

    var
    DimMgt: Codeunit DimensionManagement;
    local procedure CreateDimFromEmployee()
    var
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
    begin
        DimMgt.AddDimSource(DefaultDimSource, Database::Employee, Employee);
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        "Dimension Set ID" := DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, DefaultDimSource, '',
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
        DimCaptionLbl: Label 'Loan %1';
    begin
        if Status <> Status::Open then begin
            DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo(DimCaptionLbl, "No."));
            exit;
        end;

        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" := DimMgt.EditDimensionSet(
            Rec, "Dimension Set ID", StrSubstNo(DimCaptionLbl, "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then
            Modify(true);
    end;
}